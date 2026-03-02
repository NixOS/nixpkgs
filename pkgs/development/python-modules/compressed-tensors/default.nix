{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,

  # build-system
  setuptools,
  setuptools-scm,
  llvmPackages,

  # dependencies
  frozendict,
  loguru,
  pydantic,
  torch,
  transformers,

  # tests
  nbconvert,
  nbformat,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "compressed-tensors";
  version = "0.13.0";
  pyproject = true;

  # Release on PyPI is missing the `utils` directory, which `setup.py` wants to import
  src = fetchFromGitHub {
    owner = "neuralmagic";
    repo = "compressed-tensors";
    tag = finalAttrs.version;
    hash = "sha256-XsQRP186ISarMMES3P+ov4t/1KKJdl0tXBrfpjyM3XA=";
  };

  #  RuntimeError("torch.compile is not supported on Python 3.14+")
  disabled = pythonAtLeast "3.14";

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools_scm==8.2.0" "setuptools_scm"
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  buildInputs = lib.optional stdenv.cc.isClang llvmPackages.openmp;

  dependencies = [
    frozendict
    loguru
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
    "test_expand_targets_with_llama_stories"
  ];

  disabledTestPaths = [
    # these try to download models from HF Hub
    "tests/test_quantization/lifecycle/test_apply.py"
    # RuntimeError: The weights trying to be saved contained shared tensors
    "tests/test_transform/factory/test_serialization.py::test_serialization[True-hadamard]"
    "tests/test_transform/factory/test_serialization.py::test_serialization[True-random-hadamard]"
    "tests/test_transform/factory/test_serialization.py::test_serialization[False-hadamard]"
    "tests/test_transform/factory/test_serialization.py::test_serialization[False-random-hadamard]"
  ];

  meta = {
    description = "Safetensors extension to efficiently store sparse quantized tensors on disk";
    homepage = "https://github.com/neuralmagic/compressed-tensors";
    changelog = "https://github.com/neuralmagic/compressed-tensors/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sarahec ];
  };
})
