{
  lib,
  buildPythonPackage,
  fetchPypi,
  pbkdf2,
  requests,
  cashaddress,
  pyperclip,
  setuptools,
  base58,
}:

buildPythonPackage rec {
  pname = "pycryptotools";
  version = "0.3.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zfXHvEaSlDXAeKnmymytRt5Z6fBG/RH5R7j5ieg3rAU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pbkdf2
    requests
    cashaddress
    pyperclip
    base58
  ];

  pythonImportsCheck = [ "pycryptotools" ];

  meta = {
    description = "Python library for Crypto coins signatures and transactions";
    homepage = "https://pypi.org/project/pycryptotools/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eymeric ];
  };
}
