{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  msal,
  portalocker,
  setuptools,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "msal-extensions";
  version = "1.2.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "AzureAD";
    repo = "microsoft-authentication-extensions-for-python";
    rev = "refs/tags/${version}";
    hash = "sha256-javYE1XDW1yrMZ/BLqIu/pUXChlBZlACctbD2RfWuis=";
  };

  build-system = [ setuptools ];

  dependencies = [
    msal
    portalocker
  ];

  # No tests found
  doCheck = false;

  pythonImportsCheck = [ "msal_extensions" ];

  meta = with lib; {
    description = "Microsoft Authentication Library Extensions (MSAL-Extensions) for Python";
    homepage = "https://github.com/AzureAD/microsoft-authentication-extensions-for-python";
    changelog = "https://github.com/AzureAD/microsoft-authentication-extensions-for-python/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ kamadorueda ];
  };
}
