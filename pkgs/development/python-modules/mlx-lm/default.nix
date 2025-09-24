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
  lm-eval,
  sentencepiece,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "mlx-lm";
  version = "0.26.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ml-explore";
    repo = "mlx-lm";
    tag = "v${version}";
    hash = "sha256-O4wW7wvIqSeBv01LoUCHm0/CgcRc5RfFHjvwyccp6UM=";
  };

  build-system = [
    setuptools
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
    lm-eval
    pytestCheckHook
    sentencepiece
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [
    "mlx_lm"
  ];

  disabledTestPaths = [
    # Requires network access to huggingface.co
    "tests/test_datsets.py"
    "tests/test_generate.py"
    "tests/test_server.py"
    "tests/test_tokenizers.py"
    "tests/test_utils.py::TestUtils::test_convert"
    "tests/test_utils.py::TestUtils::test_load"
    "tests/test_utils_load_model.py"
    "tests/test_prompt_cache.py::TestPromptCache::test_cache_to_quantized"
    "tests/test_prompt_cache.py::TestPromptCache::test_cache_with_generate"
    "tests/test_prompt_cache.py::TestPromptCache::test_trim_cache_with_generate"
    # RuntimeError: [metal_kernel] No GPU back-end.
    "tests/test_losses.py"
    "tests/test_models.py::TestModels::test_bitnet"
  ];

  meta = {
    description = "Run LLMs with MLX";
    homepage = "https://github.com/ml-explore/mlx-lm";
    changelog = "https://github.com/ml-explore/mlx-lm/releases/tag/v${version}";
    license = lib.licenses.mit;
    platforms = [
      "aarch64-darwin"
    ];
    maintainers = with lib.maintainers; [ ferrine ];
  };
}
