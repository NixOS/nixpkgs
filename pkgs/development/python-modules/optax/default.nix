{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  flit-core,

  # dependencies
  absl-py,
  chex,
  jax,
  jaxlib,
  numpy,

  # tests
  callPackage,
}:

buildPythonPackage rec {
  pname = "optax";
  version = "0.2.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "deepmind";
    repo = "optax";
    tag = "v${version}";
    hash = "sha256-EGQeRYSxHdENqB3QPZFsjqwh4LYT5CF8E1K3fKFedPg=";
  };

  outputs = [
    "out"
    "testsout"
  ];

  build-system = [ flit-core ];

  dependencies = [
    absl-py
    chex
    jax
    jaxlib
    numpy
  ];

  postInstall = ''
    mkdir $testsout
    cp -R examples $testsout/examples
  '';

  pythonImportsCheck = [ "optax" ];

  # check in passthru.tests.pytest to escape infinite recursion with flax
  doCheck = false;

  passthru.tests = {
    pytest = callPackage ./tests.nix { };
  };

  meta = {
    description = "Gradient processing and optimization library for JAX";
    homepage = "https://github.com/deepmind/optax";
    changelog = "https://github.com/deepmind/optax/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ndl ];
  };
}
