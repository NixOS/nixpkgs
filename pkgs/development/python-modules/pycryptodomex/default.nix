{ lib
, buildPythonPackage
, fetchPypi
, pycryptodome-test-vectors
}:

buildPythonPackage rec {
  pname = "pycryptodomex";
  version = "3.12.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ki6drAFm5GF+XHmA0s/2kSputctcE+fs4iJDhlC9f2Y=";
    extension = "zip";
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
