{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "groestlcoin_hash";
  version = "1.0.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "31a8f6fa4c19db5258c3c73c071b71702102c815ba862b6015d9e4b75ece231e";
  };

  pythonImportsCheck = [
    "groestlcoin_hash"
  ];

  meta = with lib; {
    description = "Bindings for groestl key derivation function library used in Groestlcoin";
    homepage = "https://pypi.org/project/groestlcoin_hash/";
    maintainers = with maintainers; [ gruve-p ];
    license = licenses.mit;
  };
}
