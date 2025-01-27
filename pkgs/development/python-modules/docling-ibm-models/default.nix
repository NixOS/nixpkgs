{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  huggingface-hub,
  jsonlines,
  mean-average-precision,
  numpy,
  opencv-python-headless,
  pillow,
  torch,
  torchvision,
  tqdm,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "docling-ibm-models";
  version = "3.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DS4SD";
    repo = "docling-ibm-models";
    tag = "v${version}";
    hash = "sha256-GtVQwUcKJKS7PYpvI54obcOqx0TbOYkeKR5XXfcHaqY=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    huggingface-hub
    jsonlines
    mean-average-precision
    numpy
    opencv-python-headless
    pillow
    torch
    torchvision
    tqdm
  ];

  pythonRelaxDeps = [
    "mean_average_precision"
    "pillow"
    "torchvision"
  ];

  pythonImportsCheck = [
    "docling_ibm_models"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # Requires network access
    "test_layoutpredictor"
    "test_tf_predictor"
  ];

  meta = {
    changelog = "https://github.com/DS4SD/docling-ibm-models/blob/${src.tag}/CHANGELOG.md";
    description = "Docling IBM models";
    homepage = "https://github.com/DS4SD/docling-ibm-models";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
  };
}
