{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pycryptodomex";
  version = "3.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0398366656bb55ebdb1d1d493a7175fc48ade449283086db254ac44c7d318d6d";
  };

  pythonImportsCheck = [ "Cryptodome" ];

  meta = with lib; {
    description = "A self-contained cryptographic library for Python";
    homepage = "https://www.pycryptodome.org";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fab ];
  };
}
