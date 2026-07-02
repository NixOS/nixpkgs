{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  accelerate,
  docling-core,
  huggingface-hub,
  jsonlines,
  numpy,
  opencv-python-headless,
  pillow,
  pydantic,
  rtree,
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

buildPythonPackage (finalAttrs: {
  pname = "docling-ibm-models";
  version = "3.13.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "docling-project";
    repo = "docling-ibm-models";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PYIcsKffrsZl4f9SFinUdrvUVEXm1fO/n7ZxXuiiByU=";
  };

  build-system = [
    poetry-core
  ];

  pythonRelaxDeps = [
    "jsonlines"
    "numpy"
    "transformers"
  ];
  dependencies = [
    accelerate
    docling-core
    huggingface-hub
    jsonlines
    numpy
    opencv-python-headless
    pillow
    pydantic
    rtree
    safetensors
    torch
    torchvision
    tqdm
    transformers
  ];

  pythonImportsCheck = [ "docling_ibm_models" ];

  nativeCheckInputs = [
    datasets
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  disabledTestPaths = [
    # Require network access
    "tests/test_tableformer_v2.py"
  ];

  disabledTests = [
    # Require network access
    "test_code_formula_predictor" # huggingface_hub.errors.LocalEntryNotFoundError
    "test_figure_classifier" # huggingface_hub.errors.LocalEntryNotFoundError
    "test_layoutpredictor"
    "test_readingorder"
    "test_tf_predictor"
  ];

  meta = {
    changelog = "https://github.com/DS4SD/docling-ibm-models/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Docling IBM models";
    homepage = "https://github.com/DS4SD/docling-ibm-models";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
