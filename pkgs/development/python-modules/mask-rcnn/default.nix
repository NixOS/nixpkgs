{ buildPythonPackage
, cython
, fetchFromGitHub
, h5py
, imgaug
, ipython
, Keras
, lib
, matplotlib
, numpy
, opencv3
, pillow
, scikitimage
, scipy
, tensorflow
}:

buildPythonPackage rec {
  pname = "mask-rcnn";
  version = "2.1";
  
  src = fetchFromGitHub {
    owner = "matterport";
    repo = "Mask_RCNN";
    rev = "3deaec5d902d16e1daf56b62d5971d428dc920bc";
    sha256 = "13s3q9yh2q9m9vyksd269mww3bni4q2w7q5l419q70ca075qp8zp";
  };

  nativeBuildInputs = [ cython ];

  propagatedBuildInputs = [
    h5py
    imgaug
    ipython
    Keras
    matplotlib
    numpy
    opencv3
    pillow
    scikitimage
    scipy
    tensorflow
  ];

  meta = with lib; {
    description = "Mask R-CNN for object detection and instance segmentation on Keras and TensorFlow";
    homepage = "https://github.com/matterport/Mask_RCNN";
    license = licenses.mit;
    maintainers = with maintainers; [ rakesh4g ];
  };
}

