{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  base58,
  cashaddress,
  pbkdf2,
  requests,
}:

buildPythonPackage rec {
  pname = "pycryptotools";
  version = "0.3.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oXvBit2Z8o6QXC12ob1jX9A0wsev6Kfbtwz/fBmnRls=";
  };

  build-system = [ setuptools ];

  dependencies = [
    base58
    cashaddress
    pbkdf2
    requests
  ];

  pythonImportsCheck = [ "pycryptotools" ];

  meta = {
    description = "Python crypto coin tools";
    homepage = "https://github.com/Toporin/pycryptotools";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ stargate01 ];
  };
}
