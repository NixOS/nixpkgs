{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  # Build system
  setuptools,
  # Dependencies
  numpy,
  # Optional dependencies
  orjson,
  tqdm,
  pystemmer,
  numba,
  huggingface-hub,
  black,
  jax,
  scipy,
  pytrec-eval,
  mcp,
  rich,
  # Tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "bm25s";
  version = "0.3.9";
  pyproject = true;

  # Set the version of the package in main.py
  BM25S_VERSION = finalAttrs.version;

  src = fetchFromGitHub {
    owner = "xhluca";
    repo = "bm25s";
    tag = "${finalAttrs.version}";
    hash = "sha256-/aIQCJnOInjaxRTbAJgYMs20zEayWLz+uBKGhqX5ULM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
  ];

  optional-dependencies = {
    core = [
      orjson
      tqdm
      pystemmer
      numba
    ];
    stem = [
      pystemmer
    ];
    hf = [
      huggingface-hub
    ];
    dev = [
      black
    ];
    selection = [
      jax
    ];
    indexing = [
      scipy
    ];
    evaluation = [
      pytrec-eval
    ];
    mcp = [
      mcp
    ];
    cli = [
      rich
    ];
    full = [
      orjson
      tqdm
      pystemmer
      numba
      huggingface-hub
      black
      jax
      scipy
      pytrec-eval
      mcp
      rich
    ];
  };

  # Tests
  pythonImportsCheck = [ "bm25s" ];
  # Package tests require all optional dependencies
  nativeCheckInputs = [ pytestCheckHook ] ++ finalAttrs.passthru.optional-dependencies.full;
  enabledTestPaths = [
    "tests"
  ];
  disabledTestPaths = [
    # Tests under tests/comparison and tests/comparison_full require additional data
    "tests/comparison"
    "tests/comparison_full"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "An ultra-fast implementation of BM25 based on sparse matrices";
    homepage = "https://github.com/xhluca/bm25s/";
    changelog = "https://github.com/xhluca/bm25s/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ LodWKobku ];
  };
})
