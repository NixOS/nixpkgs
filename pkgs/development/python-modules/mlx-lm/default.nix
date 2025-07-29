{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  jinja2,
  mlx,
  numpy,
  protobuf,
  pyyaml,
  transformers,
  sentencepiece,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "mlx-lm";
  version = "0.26.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ml-explore";
    repo = "mlx-lm";
    tag = "v${version}";
    hash = "sha256-J69XIqsjQ4sQqhx+EkjKcVXVlQ4A4PGJvICSiCfoSOA=";
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
    writableTmpDirAsHomeHook
    pytestCheckHook
    sentencepiece
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
    "tests/test_models.py::TestModels::test_bitnet"
  ];

  meta = {
    description = "Run LLMs with MLX";
    homepage = "https://github.com/ml-explore/mlx-lm";
    license = lib.licenses.mit;
    platforms = [
      "aarch64-darwin"
    ];
    maintainers = with lib.maintainers; [ ferrine ];
  };
}
