{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "groestlcoin-hash";
  version = "1.0.3";
  format = "setuptools";

  src = fetchPypi {
    pname = "groestlcoin_hash";
    inherit version;
    hash = "sha256-Maj2+kwZ21JYw8c8BxtxcCECyBW6hitgFdnkt17OIx4=";
  };

  pythonImportsCheck = [ "groestlcoin_hash" ];

  meta = with lib; {
    description = "Bindings for groestl key derivation function library used in Groestlcoin";
    homepage = "https://pypi.org/project/groestlcoin_hash/";
    maintainers = with maintainers; [ gruve-p ];
    license = licenses.mit;
  };
}
