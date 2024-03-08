{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, matplotlib
, numpy
, opencv4
, pillow
, scikit-learn
, setuptools
, torch
, torchvision
, ttach
, tqdm
}:

buildPythonPackage rec {
  pname = "grad-cam";
  version = "1.5.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-aw7Z/6/AMKH2PVBcOr8HxsmRDa6c3v8Xd4xa8HTiFGA=";
  };

  postPatch = ''
    substituteInPlace requirements.txt\
      --replace "opencv-python" "opencv"
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    matplotlib
    numpy
    opencv4
    pillow
    scikit-learn
    torchvision
    ttach
    tqdm
  ];

  # Let the user bring their own instance (as with torchmetrics)
  buildInputs = [
    torch
  ];

  doCheck = false;  # every nontrivial test tries to download a pretrained model

  pythonImportsCheck = [
    "pytorch_grad_cam"
    "pytorch_grad_cam.metrics"
    "pytorch_grad_cam.metrics.cam_mult_image"
    "pytorch_grad_cam.metrics.road"
    "pytorch_grad_cam.utils"
    "pytorch_grad_cam.utils.image"
    "pytorch_grad_cam.utils.model_targets"
  ];

  meta = with lib; {
    description = "Advanced AI explainability for computer vision.";
    homepage = "https://jacobgil.github.io/pytorch-gradcam-book";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
