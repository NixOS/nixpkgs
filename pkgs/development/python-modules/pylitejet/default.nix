{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyserial,
  pythonOlder,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pylitejet";
  version = "0.6.3";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "joncar";
    repo = "pylitejet";
    tag = "v${version}";
    hash = "sha256-LHNMKU7aMDtSi4K+pZqRF9vAL3EKOFRFFNXKsQJVP2Y=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [ pyserial ];

  # Only custom tests which uses the CLi are available
  doCheck = false;

  pythonImportsCheck = [ "pylitejet" ];

  meta = {
    description = "Library for interfacing with the LiteJet lighting system";
    homepage = "https://github.com/joncar/pylitejet";
    changelog = "https://github.com/joncar/pylitejet/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
