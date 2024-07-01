{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pycryptodome-test-vectors";
  version = "1.0.14";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1De0SjXcr8BibDVhv7G1BqG3x0RcxfudNuI3QWG8mjc=";
    extension = "zip";
  };

  nativeBuildInputs = [ setuptools ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "pycryptodome_test_vectors" ];

  meta = with lib; {
    description = "Test vectors for PyCryptodome cryptographic library";
    homepage = "https://www.pycryptodome.org/";
    license = with licenses; [
      bsd2 # and
      asl20
    ];
    maintainers = with maintainers; [ fab ];
  };
}
