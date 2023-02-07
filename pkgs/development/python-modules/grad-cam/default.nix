{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, matplotlib
, numpy
, opencv4
, pillow
, scikitlearn
, torch
, torchvision
, ttach
, tqdm
}:

buildPythonPackage rec {
  pname = "grad-cam";
  version = "1.4.6";
  disabled = pythonOlder "3.6";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sL4+UUfC60JWAgJPvXeVGUHAskuoceVYwYDrYlibUOE=";
  };

  postPatch = ''
    substituteInPlace requirements.txt --replace "opencv-python" "opencv"
  '';

  propagatedBuildInputs = [
    matplotlib
    numpy
    opencv4
    pillow
    scikitlearn
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
