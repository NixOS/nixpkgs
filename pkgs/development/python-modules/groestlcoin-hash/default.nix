{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "groestlcoin-hash";
  version = "1.0.3";
  pyproject = true;

  src = fetchPypi {
    pname = "groestlcoin_hash";
    inherit version;
    sha256 = "31a8f6fa4c19db5258c3c73c071b71702102c815ba862b6015d9e4b75ece231e";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "groestlcoin_hash" ];

  meta = {
    description = "Bindings for groestl key derivation function library used in Groestlcoin";
    homepage = "https://pypi.org/project/groestlcoin_hash/";
    maintainers = with lib.maintainers; [ gruve-p ];
    license = lib.licenses.mit;
  };
}
