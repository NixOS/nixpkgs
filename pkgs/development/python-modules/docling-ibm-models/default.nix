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
  version = "3.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "docling-project";
    repo = "docling-ibm-models";
    tag = "v${finalAttrs.version}";
    hash = "sha256-T8sVXG9s7jlhoRNexPRmCaiHPtQUAhDa9Z0Ri9i0zcc=";
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
    # Requires network access
    "test_figure_classifier"
    "test_layoutpredictor"
    "test_readingorder"
    "test_tableformer_v2_model_loading"
    "test_tableformer_v2_tokenizer_loading"
    "test_tableformer_v2_image_encoding"
    "test_tableformer_v2_forward_pass"
    "test_tableformer_v2_predict"
    "test_tableformer_v2_numpy_input"
    "test_tableformer_v2_batch_inference"
    "test_tableformer_v2_unsupported_input"
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
