{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "ptest";
  version = "2.0.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "KarlGong";
    repo = "ptest";
    tag = "${version}-release";
    hash = "sha256-lmiBqFWGfYdsBXCh6dQ9xed+HhpP6PWa9Csr68GtLxs=";
  };

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "(.*)-release"
    ];
  };

  meta = with lib; {
    description = "Test classes and test cases using decorators, execute test cases by command line, and get clear reports";
    homepage = "https://pypi.python.org/pypi/ptest";
    license = licenses.asl20;
  };
}
