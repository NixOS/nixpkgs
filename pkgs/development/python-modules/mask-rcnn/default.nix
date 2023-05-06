{ buildPythonPackage
, cython
, fetchFromGitHub
, fetchpatch
, h5py
, imgaug
, ipython
, keras
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

  patches = [
    # Fix for TF2:
    # https://github.com/matterport/Mask_RCNN/issues/2734
    (fetchpatch {
      url = "https://github.com/BupyeongHealer/Mask_RCNN_tf_2.x/commit/7957839fe2b248f2f22c7e991ead12068ddc6cfc.diff";
      excludes = [ "mrcnn/model.py" ];
      hash = "sha256-70BGrx6X1uJDA2025f0YTlreT2uB3n35yIzuhf+ypVc=";
    })
  ];

  # Fix for recent Keras
  postPatch = ''
    substituteInPlace mrcnn/model.py \
      --replace "KE." "KL."
  '';

  nativeBuildInputs = [ cython ];

  propagatedBuildInputs = [
    h5py
    imgaug
    ipython
    keras
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
