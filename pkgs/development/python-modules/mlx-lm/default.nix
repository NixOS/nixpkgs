{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  jinja2,
  mlx,
  numpy,
  protobuf,
  pyyaml,
  transformers,

  # tests
  aiohttp,
  lm-eval,
  pytestCheckHook,
  sentencepiece,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "mlx-lm";
  version = "0.30.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ml-explore";
    repo = "mlx-lm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ncDg7C84d1tAgk1300N7wY6kD1BocNNIqDUl0xBLhqY=";
  };

  build-system = [
    setuptools
  ];

  pythonRelaxDeps = [
    "transformers"
  ];
  dependencies = [
    jinja2
    mlx
    numpy
    protobuf
    pyyaml
    transformers
  ];

  nativeCheckInputs = [
    aiohttp
    lm-eval
    pytestCheckHook
    sentencepiece
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "mlx_lm" ];

  disabledTestPaths = [
    # Requires network access to huggingface.co
    "tests/test_datsets.py"
    "tests/test_generate.py"
    "tests/test_prompt_cache.py::TestPromptCache"
    "tests/test_server.py"
    "tests/test_tokenizers.py"
    "tests/test_utils.py::TestUtils::test_convert"
    "tests/test_utils.py::TestUtils::test_load"

    # RuntimeError: [metal_kernel] No GPU back-end.
    "tests/test_losses.py"
    "tests/test_models.py::TestModels::test_bitnet"

    # TypeError: 'NoneType' object is not callable
    "tests/test_models.py::TestModels::test_gated_delta"
    "tests/test_models.py::TestModels::test_gated_delta_masked"
  ];

  meta = {
    description = "Run LLMs with MLX";
    homepage = "https://github.com/ml-explore/mlx-lm";
    changelog = "https://github.com/ml-explore/mlx-lm/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
  };
})
