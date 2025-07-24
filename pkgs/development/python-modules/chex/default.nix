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
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "chex";
  version = "0.1.90";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "deepmind";
    repo = "chex";
    tag = "v${version}";
    hash = "sha256-nZYfkK73p3HpUOMPyqkV4YR3BDGrpdZrl36dmfZt7Bk=";
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
    description = "Library of utilities for helping to write reliable JAX code";
    homepage = "https://github.com/deepmind/chex";
    changelog = "https://github.com/google-deepmind/chex/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ndl ];
  };
}
