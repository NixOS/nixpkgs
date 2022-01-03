{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pycryptodome-test-vectors";
  version = "1.0.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2+ZL8snmaB0tNxGZRbUM6SdfXZf4CM0nh3/wTOu9R50=";
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
