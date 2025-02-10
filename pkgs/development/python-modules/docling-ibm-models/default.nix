{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  # dependencies
  torch,
  torchvision,
  transformers,
  huggingface-hub,
  jsonlines,
  numpy,
  opencv-python-headless,
  pillow,
  tqdm,
  safetensors,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "docling-ibm-models";
  version = "3.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DS4SD";
    repo = "docling-ibm-models";
    tag = "v${version}";
    hash = "sha256-wxkHd+TCBibOTWO09JOsjX6oBtUxZ/9IOmyLdeptzeQ=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    torch
    torchvision
    transformers
    numpy
    jsonlines
    pillow
    tqdm
    opencv-python-headless
    huggingface-hub
    safetensors
  ];

  pythonRelaxDeps = [
    "pillow"
    "torchvision"
    "transformers"
    "numpy"
  ];

  pythonImportsCheck = [
    "docling_ibm_models"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    export HOME="$TEMPDIR"
  '';

  disabledTests = [
    # Requires network access
    "test_layoutpredictor"
    "test_tf_predictor"
    "test_code_formula_predictor" # huggingface_hub.errors.LocalEntryNotFoundError
    "test_figure_classifier" # huggingface_hub.errors.LocalEntryNotFoundError
  ];

  meta = {
    changelog = "https://github.com/DS4SD/docling-ibm-models/blob/${src.tag}/CHANGELOG.md";
    description = "Docling IBM models";
    homepage = "https://github.com/DS4SD/docling-ibm-models";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
  };
}
