# -*- coding: utf-8 -*-

import os
import cv2
from imwatermark import WatermarkEncoder

input_file_path = os.environ['image']
output_dir = os.environ['out']
message = os.environ['message']
method = os.environ['method']

os.mkdir(output_dir)

bgr = cv2.imread(input_file_path)

encoder = WatermarkEncoder()
encoder.set_watermark('bytes', message.encode('utf-8'))
bgr_encoded = encoder.encode(bgr, method)

output_file = os.path.join(output_dir, 'test_wm.png')
cv2.imwrite(output_file, bgr_encoded)
