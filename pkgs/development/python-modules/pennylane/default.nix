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
  # pennylane-lightning,
  requests,
  tomlkit,
  typing-extensions,
  packaging,
  diastatic-malt,
  numpy,
}:

buildPythonPackage rec {
  pname = "pennylane";
  version = "0.41.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  # Use fetchPypi to avoid the updater script to migrate it to `reactivex` which
  # is being developed in the same repository
  src = fetchFromGitHub {
    owner = "PennyLaneAI";
    repo = "pennylane";
    tag = "v${version}";
    hash = "sha256-jJJOZ+VUO3oxi5O65QxnxMn8mzwlEBGe1Kgz2WdtcfQ=";
  };

  build-system = [ setuptools ];

  doCheck = false;

  pythonImportsCheck = [ "pennylane" ];

  pythonRemoveDeps = [
    "pennylane-lightning"
  ];

  dependencies = [
    scipy
    networkx
    rustworkx
    autograd
    appdirs
    autoray
    cachetools
    # pennylane-lightning
    requests
    tomlkit
    typing-extensions
    packaging
    diastatic-malt
    numpy
  ];

  meta = {
    homepage = "https://pennylane.ai";
    description = "Python framework for quantum programming";
    maintainers = with lib.maintainers; [ anderscs ];
    license = lib.licenses.asl20;
  };
}
