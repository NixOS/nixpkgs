{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  absl-py,
  etils,
  flax,
  jax,
  jaxlib,
  ml-collections,
  numpy,
  packaging,
  typing-extensions,
  wrapt,

  # tests
  keras,
  pytestCheckHook,
  tensorflow,
  tensorflow-datasets,
  torch,
}:

buildPythonPackage rec {
  pname = "clu";
  version = "0.0.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "google";
    repo = "CommonLoopUtils";
    tag = "v${version}";
    hash = "sha256-ntqRz3fCXMf0EDQsddT68Mdi105ECBVQpVsStzk2kvQ=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    absl-py
    etils
    flax
    jax
    jaxlib
    ml-collections
    numpy
    packaging
    typing-extensions
    wrapt
  ]
  ++ etils.optional-dependencies.epath;

  pythonImportsCheck = [ "clu" ];

  nativeCheckInputs = [
    keras
    pytestCheckHook
    tensorflow
    tensorflow-datasets
    torch
  ];

  disabledTests = [
    # AssertionError: [Chex] Assertion assert_trees_all_close failed
    "test_collection_mixed_async"
  ];

  meta = {
    description = "Common training loops in JAX";
    homepage = "https://github.com/google/CommonLoopUtils";
    changelog = "https://github.com/google/CommonLoopUtils/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
