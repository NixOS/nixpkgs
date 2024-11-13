{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,

  # build-system
  flit-core,

  # dependencies
  absl-py,
  chex,
  jax,
  jaxlib,
  numpy,
  etils,

  # checks
  callPackage,
}:

buildPythonPackage rec {
  pname = "optax";
  version = "0.2.4";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "deepmind";
    repo = "optax";
    rev = "refs/tags/v${version}";
    hash = "sha256-7UPWeo/Q9/tjewaM7HN8/e7U1U1QzAliuk95+9GOi0E=";
  };

  outputs = [
    "out"
    "testsout"
  ];

  build-system = [ flit-core ];

  dependencies = [
    absl-py
    chex
    etils
    jax
    jaxlib
    numpy
  ] ++ etils.optional-dependencies.epy;

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

  meta = with lib; {
    description = "Gradient processing and optimization library for JAX";
    homepage = "https://github.com/deepmind/optax";
    changelog = "https://github.com/deepmind/optax/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ ndl ];
  };
}
