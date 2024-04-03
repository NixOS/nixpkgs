{ lib
, absl-py
, buildPythonPackage
, flit-core
, chex
, fetchFromGitHub
, jaxlib
, numpy
, callPackage
, pythonOlder
}:

buildPythonPackage rec {
  pname = "optax";
  version = "0.2.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "deepmind";
    repo = "optax";
    rev = "refs/tags/v${version}";
    hash = "sha256-sBiKUuQR89mttc9Njrh1aeUJOYdlcF7Nlj3/+Y7OMb4=";
  };

  outputs = [
    "out"
    "testsout"
  ];

  nativeBuildInputs = [
    flit-core
  ];

  buildInputs = [
    jaxlib
  ];

  propagatedBuildInputs = [
    absl-py
    chex
    numpy
  ];

  postInstall = ''
    mkdir $testsout
    cp -R examples $testsout/examples
  '';

  pythonImportsCheck = [
    "optax"
  ];

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
