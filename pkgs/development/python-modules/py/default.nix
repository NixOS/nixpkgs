{ lib, buildPythonPackage, fetchPypi, setuptools-scm }:

buildPythonPackage rec {
  pname = "py";
  version = "1.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "21b81bda15b66ef5e1a777a21c4dcd9c20ad3efd0b3f817e7a809035269e1bd3";
  };

  # Circular dependency on pytest
  doCheck = false;

  nativeBuildInputs = [ setuptools-scm ];

  pythonImportsCheck = [
    "py"
  ];

  meta = with lib; {
    description = "Library with cross-python path, ini-parsing, io, code, log facilities";
    homepage = "https://py.readthedocs.io/";
    license = licenses.mit;
  };
}
