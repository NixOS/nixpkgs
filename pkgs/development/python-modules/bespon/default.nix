{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  version = "0.7.0";
  pname = "bespon";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dGtXw4uq6pdyXBVfSi9s7kCFUqA1PO7qWEGY0JNAz8Q=";
  };

  nativeBuildInputs = [ setuptools ];
  # upstream doesn't contain tests
  doCheck = false;

  pythonImportsCheck = [ "bespon" ];
  meta = with lib; {
    description = "Encodes and decodes data in the BespON format.";
    homepage = "https://github.com/gpoore/bespon_py";
    license = licenses.bsd3;
    maintainers = with maintainers; [ synthetica ];
  };
}
