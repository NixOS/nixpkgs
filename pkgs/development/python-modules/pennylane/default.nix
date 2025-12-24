{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,
  setuptools,
  # Python dependencies
  scipy,
  networkx,
  rustworkx,
  autograd,
  appdirs,
  autoray,
  cachetools,
  pennylane-lightning-bin,
  requests,
  tomlkit,
  typing-extensions,
  packaging,
  diastatic-malt,
  numpy,
  # test
  jax, # only full support for 0.7.0
  optax,
  pytestCheckHook,
  sybil,
  flaky,
  matplotlib,
}:

buildPythonPackage rec {
  pname = "pennylane";
  version = "0.43.2";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "PennyLaneAI";
    repo = "pennylane";
    tag = "v${version}";
    hash = "sha256-in57w19nWUUqVhK63ObQ3HSnphKmcmw8feqh/Aypm7c=";
  };

  build-system = [ setuptools ];

  doCheck = false; # Tests are very time consuming

  pythonImportsCheck = [ "pennylane" ];

  dependencies = [
    scipy
    networkx
    rustworkx
    autograd
    appdirs
    autoray
    cachetools
    pennylane-lightning-bin
    requests
    tomlkit
    typing-extensions
    packaging
    diastatic-malt
    numpy
  ];

  disabledTestPaths = [
    "doc/"
    "pennylane/"
    "tests/capture/"
    "tests/data/attributes/operator/test_operator.py"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    matplotlib
    sybil
    flaky
    jax
    optax
  ];

  meta = {
    homepage = "https://pennylane.ai";
    description = "Python framework for quantum programming";
    maintainers = with lib.maintainers; [ anderscs ];
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.asl20;
  };
}
