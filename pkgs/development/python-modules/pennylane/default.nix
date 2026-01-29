{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  # Python dependencies
  scipy,
  networkx,
  rustworkx,
  autograd,
  appdirs,
  autoray,
  cachetools,
  requests,
  tomlkit,
  typing-extensions,
  packaging,
  diastatic-malt,
  numpy,
  # test
  jax, # only full support for 0.6.0
  jaxlib,
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

  src = fetchFromGitHub {
    owner = "PennyLaneAI";
    repo = "pennylane";
    tag = "v${version}";
    hash = "sha256-in57w19nWUUqVhK63ObQ3HSnphKmcmw8feqh/Aypm7c=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = true;

  dependencies = [
    scipy
    networkx
    rustworkx
    autograd
    appdirs
    autoray
    cachetools
    requests
    tomlkit
    typing-extensions
    packaging
    diastatic-malt
    numpy
  ];

  pythonRemoveDeps = [
    "pennylane-lightning" # Circular runtime only dependency
  ];

  nativeCheckInputs = [
    pytestCheckHook
    matplotlib
    sybil
    flaky
    jax
    jaxlib
    optax
  ];

  # Tests are very time consuming and many will fail since it only supports jax and jaxlib 0.6.0
  doCheck = false;

  pythonImportsCheck = [ "pennylane" ];

  meta = {
    homepage = "https://pennylane.ai";
    changelog = "https://github.com/PennyLaneAI/pennylane/releases/tag/${src.tag}";
    description = "Python framework for quantum programming";
    teams = [ lib.teams.quantum ];
    license = lib.licenses.asl20;
  };
}
