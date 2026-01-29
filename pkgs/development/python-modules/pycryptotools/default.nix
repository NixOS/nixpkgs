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

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zfXHvEaSlDXAeKnmymytRt5Z6fBG/RH5R7j5ieg3rAU=";
  };

  dependencies = [
    pbkdf2
    requests
    cashaddress
    pyperclip
    base58
  ];

  pyproject = true;
  build-system = [ setuptools ];

  pythonImportsCheck = [ "pycryptotools" ];

  meta = {
    changelog = "https://pypi.org/project/pycryptotools/#history";
    description = "Python library for Crypto coins signatures and transactions";
    homepage = "https://pypi.org/project/pycryptotools/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eymeric ];
  };
}
