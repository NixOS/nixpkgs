{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  absl-py,
  jax,
  jaxlib,
  numpy,
  toolz,
  typing-extensions,

  # tests
  cloudpickle,
  dm-tree,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "chex";
  version = "0.1.87";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "deepmind";
    repo = "chex";
    rev = "refs/tags/v${version}";
    hash = "sha256-TPh7XLWHk0y/VLXxHLANUiDmfveHPeMLks9QKf16doo=";
  };

  build-system = [ setuptools ];

  dependencies = [
    absl-py
    jax
    jaxlib
    numpy
    toolz
    typing-extensions
  ];

  pythonImportsCheck = [ "chex" ];

  nativeCheckInputs = [
    cloudpickle
    dm-tree
    pytestCheckHook
  ];

  meta = {
    description = "Chex is a library of utilities for helping to write reliable JAX code";
    homepage = "https://github.com/deepmind/chex";
    changelog = "https://github.com/google-deepmind/chex/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ndl ];
  };
}
