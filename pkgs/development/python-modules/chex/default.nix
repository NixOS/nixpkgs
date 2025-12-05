{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  flit-core,

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
  version = "0.1.91";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "deepmind";
    repo = "chex";
    tag = "v${version}";
    hash = "sha256-lJ9+kvG7dRtfDVgvkcJ9/jtnX0lMfxY4mmZ290y/74U=";
  };

  build-system = [
    flit-core
  ];

  pythonRelaxDeps = [
    "typing_extensions"
  ];
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
