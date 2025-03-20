{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pydantic,
  torch,
  transformers,
  nbconvert,
  nbformat,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "compressed-tensors";
  version = "0.9.2";
  pyproject = true;

  # Release on PyPI is missing the `utils` directory, which `setup.py` wants to import
  src = fetchFromGitHub {
    owner = "neuralmagic";
    repo = pname;
    tag = version;
    hash = "sha256-PxW8zseDUF0EOh7E/N8swwgFTfvkoTpp+d3ngAUpFNU=";
  };

  build-system = [ setuptools ];

  dependencies = [
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
    "test_get_observer_token_count"
    "test_kv_cache_quantization"
    "test_target_prioritization"
    "test_load_compressed_sharded"
    "test_save_compressed_model"
    "test_apply_tinyllama_dynamic_activations"
  ];

  disabledTestPaths = [
    # these try to download models from HF Hub
    "tests/test_quantization/lifecycle/test_apply.py"
  ];

  meta = with lib; {
    description = "A safetensors extension to efficiently store sparse quantized tensors on disk";
    homepage = "https://github.com/neuralmagic/compressed-tensors";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
