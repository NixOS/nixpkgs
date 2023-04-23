{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pycryptodome-test-vectors";
  version = "1.0.10";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oqgHWAw0Xrc22eAuY6+Q/H90tL9Acz6V0EJp060hH2Q=";
    extension = "zip";
  };

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "pycryptodome_test_vectors"
  ];

  meta = with lib; {
    description = "Test vectors for PyCryptodome cryptographic library";
    homepage = "https://www.pycryptodome.org/";
    license = with licenses; [ bsd2 /* and */ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
