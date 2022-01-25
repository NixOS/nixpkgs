{ lib
, buildPythonPackage
, fetchPypi
, pycryptodome-test-vectors
}:

buildPythonPackage rec {
  pname = "pycryptodome";
  version = "3.12.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Esc0OuxaOz31xHJlKBsSthHybsk2e2EpGZ1n2lS3aME=";
    extension = "zip";
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
