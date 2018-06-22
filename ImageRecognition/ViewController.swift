//
//  ViewController.swift
//  ImageRecognition
//
//  Created by 涂舒舰 on 2018/3/10.
//  Copyright © 2018年 涂舒舰. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var label: UILabel!
    
    let model = Inceptionv3()
    
    @IBAction func takePhotoButtonTapped() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    func analyzeImage(_ image: CVPixelBuffer) -> String {
        do {
            let prediction = try model.prediction(image: image).classLabel
            return prediction
        } catch {
            return "Can not analyze this image."
        }
        
    }
    
    func resizeImage(_ input:UIImage) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 299, height: 299))
        input.draw(in: CGRect(x: 0, y: 0, width: 299, height: 299))
        let output = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndPDFContext()
        return output!
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        guard let image = info["UIImagePickerControllerEditedImage"] as? UIImage else { return }
        let resizedImage = resizeImage(image)
        guard let pixelBuffer = resizedImage.toPixelBuffer() else { return }
        let prediction = analyzeImage(pixelBuffer)
        imageView.image = image
        label.text = prediction
    }
    
    
    
}
