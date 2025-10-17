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
  version = "0.2.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "deepmind";
    repo = "optax";
    tag = "v${version}";
    hash = "sha256-+9Q/Amb60m65ZiJsmH93e6tQmpJlMyzVUL0A7q3mS8Y=";
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
