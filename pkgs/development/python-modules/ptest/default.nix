{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "ptest";
  version = "2.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "KarlGong";
    repo = "ptest";
    tag = "${version}-release";
    hash = "sha256-lmiBqFWGfYdsBXCh6dQ9xed+HhpP6PWa9Csr68GtLxs=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "ptest" ];

  # I don't know how to run the tests
  doCheck = false;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "(.*)-release"
    ];
  };

  meta = {
    description = "Test classes and test cases using decorators, execute test cases by command line, and get clear reports";
    homepage = "https://pypi.python.org/pypi/ptest";
    license = lib.licenses.asl20;
    mainProgram = "ptest";
  };
}
