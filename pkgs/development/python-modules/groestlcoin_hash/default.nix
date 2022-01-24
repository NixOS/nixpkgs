{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "groestlcoin_hash";
  version = "1.0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Nkco8ZA0rJaT9Mx4NIcptMvzd4h0BsRn2+gomdesirg=";
  };

  pythonImportsCheck = [
    "groestlcoin_hash"
  ];

  meta = with lib; {
    description = "Bindings for groestl key derivation function library used in Groestlcoin";
    homepage = "https://pypi.org/project/groestlcoin_hash/";
    maintainers = with maintainers; [ gruve-p ];
    license = licenses.unfree;
  };
}
