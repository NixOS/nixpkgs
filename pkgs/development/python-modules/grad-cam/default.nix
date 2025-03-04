{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  setuptools,
  matplotlib,
  numpy,
  opencv-python,
  pillow,
  scikit-learn,
  torch,
  torchvision,
  ttach,
  tqdm,
}:

buildPythonPackage rec {
  pname = "grad-cam";
  version = "1.5.4";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-kgu6bM3XWFM/0d5P1ZbNzquPC7E4tnUnHpW2FKHwEUc=";
  };

  nativeBuildInputs = [
  ];

  pythonRelaxDeps = [
    "torchvision"
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    matplotlib
    numpy
    opencv-python
    pillow
    scikit-learn
    torchvision
    ttach
    tqdm
  ];

  # Let the user bring their own instance (as with torchmetrics)
  buildInputs = [ torch ];

  doCheck = false; # every nontrivial test tries to download a pretrained model

  pythonImportsCheck = [
    "pytorch_grad_cam"
    "pytorch_grad_cam.metrics"
    "pytorch_grad_cam.metrics.cam_mult_image"
    "pytorch_grad_cam.metrics.road"
    "pytorch_grad_cam.utils"
    "pytorch_grad_cam.utils.image"
    "pytorch_grad_cam.utils.model_targets"
  ];

  meta = {
    description = "Advanced AI explainability for computer vision";
    homepage = "https://jacobgil.github.io/pytorch-gradcam-book";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
