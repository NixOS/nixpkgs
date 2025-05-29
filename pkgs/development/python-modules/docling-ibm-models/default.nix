{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  docling-core,
  huggingface-hub,
  jsonlines,
  numpy,
  opencv-python-headless,
  pillow,
  pydantic,
  safetensors,
  torch,
  torchvision,
  tqdm,
  transformers,

  # tests
  datasets,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "docling-ibm-models";
  version = "3.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "docling-project";
    repo = "docling-ibm-models";
    tag = "v${version}";
    hash = "sha256-EcBlvb6UNHe2lZFBuC4eSa6Ka82HRNnsQqK/AQuPvoA=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    docling-core
    huggingface-hub
    jsonlines
    numpy
    opencv-python-headless
    pillow
    pydantic
    safetensors
    torch
    torchvision
    tqdm
    transformers
  ];

  pythonRelaxDeps = [
    "jsonlines"
    "numpy"
    "transformers"
  ];

  pythonImportsCheck = [
    "docling_ibm_models"
  ];

  nativeCheckInputs = [
    datasets
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  disabledTests = [
    # Requires network access
    "test_code_formula_predictor" # huggingface_hub.errors.LocalEntryNotFoundError
    "test_figure_classifier" # huggingface_hub.errors.LocalEntryNotFoundError
    "test_layoutpredictor"
    "test_readingorder"
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
