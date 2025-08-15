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
  version = "0.3.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oXvBit2Z8o6QXC12ob1jX9A0wsev6Kfbtwz/fBmnRls=";
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
    description = "Pycryptotools, Python library for Crypto coins signatures and transactions";
    homepage = "https://pypi.org/project/pycryptotools/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eymeric ];
  };
}
