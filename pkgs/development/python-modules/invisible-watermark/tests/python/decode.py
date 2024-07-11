# -*- coding: utf-8 -*-

import os
import cv2
from imwatermark import WatermarkDecoder

input_file = os.environ['image']
output_file_path = os.environ['out']
num_bits = int(os.environ['num_bits'])
method = os.environ['method']

bgr = cv2.imread(input_file)

decoder = WatermarkDecoder('bytes', num_bits)
watermark = decoder.decode(bgr, method)
message = watermark.decode('utf-8')

with open(output_file_path, 'w') as f:
    f.write(message)
