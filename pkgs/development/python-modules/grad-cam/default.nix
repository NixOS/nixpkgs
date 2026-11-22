{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  matplotlib,
  numpy,
  opencv-python-headless,
  pillow,
  scikit-learn,
  torch,
  torchvision,
  ttach,
  tqdm,
}:

buildPythonPackage rec {
  pname = "grad-cam";
  version = "1.5.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jacobgil";
    repo = "pytorch-grad-cam";
    rev = "704393448a7b0c620ee2c2b9597723f1d7f17b3d";
    hash = "sha256-qNmIl+kERDiJeig6A9UjnwUd7VaO91QqhwszaszLAow=";
  };

  # Runtime sources match the 1.5.7 sdist, but GitHub's setup.py still declares 1.5.5.
  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "version='1.5.5'" "version='${version}'"
  '';

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
    opencv-python-headless
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
