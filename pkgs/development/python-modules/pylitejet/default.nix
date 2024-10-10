{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyserial,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pylitejet";
  version = "0.3.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "joncar";
    repo = "pylitejet";
    rev = "refs/tags/${version}";
    hash = "sha256-fgsAb8zvmIKtitgAQbAPfTzbEGGaj3dU6FXzlSyy4Dk=";
  };

  build-system = [ setuptools ];

  dependencies = [ pyserial ];

  # Only custom tests which uses the CLi are available
  doCheck = false;

  pythonImportsCheck = [ "pylitejet" ];

  meta = {
    description = "Library for interfacing with the LiteJet lighting system";
    homepage = "https://github.com/joncar/pylitejet";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
