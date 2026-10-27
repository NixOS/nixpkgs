{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  jinja2,
  mlx,
  numpy,
  protobuf,
  pyyaml,
  sentencepiece,
  transformers,

  # optional-dependencies
  pillow,

  # tests
  aiohttp,
  lm-eval,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "mlx-lm";
  version = "0.32.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ml-explore";
    repo = "mlx-lm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xXFzkqA1++4vi5RT7TNyhSTfRzoJ+CS9l31BYZUWOPA=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    jinja2
    mlx
    numpy
    protobuf
    pyyaml
    sentencepiece
    transformers
  ];

  optional-dependencies = {
    vision = [
      pillow
    ];
  };

  nativeCheckInputs = [
    aiohttp
    lm-eval
    pytestCheckHook
    writableTmpDirAsHomeHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

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
    "tests/test_muse_spark.py::TestMuseSpark"

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
