{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "jsonpointer";
  version = "3.1.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-C4AcfbM6kEAk9gBNUm3MU7u4pKD04yv9EL6t9grfGQA=";
  };

  meta = {
    description = "Resolve JSON Pointers in Python";
    mainProgram = "jsonpointer";
    homepage = "https://github.com/stefankoegl/python-json-pointer";
    license = lib.licenses.bsd2; # "Modified BSD license, says pypi"
  };
}
