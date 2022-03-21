{ lib
, buildPythonPackage
, fetchPypi
, pycryptodome-test-vectors
}:

buildPythonPackage rec {
  pname = "pycryptodome";
  version = "3.14.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4E5Ap/jBZpGVU2o3l53YfaLDLb3HPW/jXwB3sMF8gDs=";
  };

  pythonImportsCheck = [
    "Crypto"
  ];

  meta = with lib; {
    description = "Python Cryptography Toolkit";
    homepage = "https://www.pycryptodome.org/";
    license = with licenses; [ bsd2 /* and */ asl20 ];
    maintainers = with maintainers; [ fab ];
    platforms = platforms.unix;
  };
}
