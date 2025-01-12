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
  version = "0.1.88";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "deepmind";
    repo = "chex";
    tag = "v${version}";
    hash = "sha256-umRq+FZwyx1hz839ZibRTEFKjbBugrfUJuE8PagjqI4=";
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

  # AttributeError: module 'unittest' has no attribute 'makeSuite'
  # https://github.com/google-deepmind/chex/issues/371
  # TODO: re-enable at next release
  doCheck = pythonOlder "3.13";

  meta = {
    description = "Library of utilities for helping to write reliable JAX code";
    homepage = "https://github.com/deepmind/chex";
    changelog = "https://github.com/google-deepmind/chex/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ndl ];
  };
}
