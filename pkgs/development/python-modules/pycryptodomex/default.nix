{ lib
, buildPythonPackage
, fetchPypi
, pycryptodome-test-vectors
}:

buildPythonPackage rec {
  pname = "pycryptodomex";
  version = "3.14.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LOdu0Agf1qyMdO3HW50U7KIGQXOveYQ8JPpiVzJjwfI=";
  };

  pythonImportsCheck = [
    "Cryptodome"
  ];

  meta = with lib; {
    description = "A self-contained cryptographic library for Python";
    homepage = "https://www.pycryptodome.org";
    license = with licenses; [ bsd2 /* and */ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
