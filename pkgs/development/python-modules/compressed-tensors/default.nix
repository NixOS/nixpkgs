{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  frozendict,
  pydantic,
  torch,
  transformers,

  # tests
  nbconvert,
  nbformat,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "compressed-tensors";
  version = "0.11.0";
  pyproject = true;

  # Release on PyPI is missing the `utils` directory, which `setup.py` wants to import
  src = fetchFromGitHub {
    owner = "neuralmagic";
    repo = "compressed-tensors";
    tag = version;
    hash = "sha256-sSXn4/N/Pn+wOCY1Z0ziqFxfMRvRA1c90jPOBe+SwZw=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools_scm==8.2.0" "setuptools_scm"
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    frozendict
    pydantic
    torch
    transformers
  ];

  doCheck = true;

  pythonImportsCheck = [ "compressed_tensors" ];

  nativeCheckInputs = [
    nbconvert
    nbformat
    pytestCheckHook
  ];

  disabledTests = [
    # these try to download models from HF Hub
    "test_apply_tinyllama_dynamic_activations"
    "test_compress_model"
    "test_compress_model_meta"
    "test_compressed_linear_from_linear_usage"
    "test_decompress_model"
    "test_get_observer_token_count"
    "test_kv_cache_quantization"
    "test_load_compressed_sharded"
    "test_model_forward_pass"
    "test_save_compressed_model"
    "test_target_prioritization"
  ];

  disabledTestPaths = [
    # these try to download models from HF Hub
    "tests/test_quantization/lifecycle/test_apply.py"
  ];

  meta = {
    description = "Safetensors extension to efficiently store sparse quantized tensors on disk";
    homepage = "https://github.com/neuralmagic/compressed-tensors";
    changelog = "https://github.com/neuralmagic/compressed-tensors/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
