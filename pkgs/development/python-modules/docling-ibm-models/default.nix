{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  huggingface-hub,
  numpy,
  opencv-python-headless,
  pillow,
  safetensors,
  torch,
  torchvision,
  transformers,

  # tests
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "docling-ibm-models";
  version = "4.0.4";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "docling-project";
    repo = "docling-ibm-models";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ELMMnDGXPfq6S7EFwuHI2Zb9PnvcBrQcfAC8ek2VCJE=";
  };

  # No [build-system] table upstream, so it falls back to setuptools
  build-system = [
    setuptools
  ];

  pythonRelaxDeps = [
    "huggingface_hub"
  ];
  dependencies = [
    huggingface-hub
    numpy
    # Declared as an optional extra upstream, but cv2 is imported unconditionally by tableformer
    opencv-python-headless
    pillow
    safetensors
    torch
    torchvision
    transformers
  ];

  pythonImportsCheck = [ "docling_ibm_models" ];

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  disabledTestPaths = [
    # Require network access
    "tests/test_tableformer_v2.py"
    "tests/test_tf_predictor.py"
  ];

  meta = {
    changelog = "https://github.com/docling-project/docling-ibm-models/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Docling IBM models";
    homepage = "https://github.com/docling-project/docling-ibm-models";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
