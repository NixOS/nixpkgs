{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pycryptodome-test-vectors";
  version = "1.0.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oNfIVm7wyhgU9pgDhdP6BVJehuEw4d238GDaYMuAYLQ=";
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
