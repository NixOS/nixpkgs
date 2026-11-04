{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "jsonpointer";
  version = "3.8";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pieiVWQTkL+01R1M+7kGSAeK6FW0WATvfhnqE6TMo1U=";
  };

  meta = {
    description = "Resolve JSON Pointers in Python";
    mainProgram = "jsonpointer";
    homepage = "https://github.com/stefankoegl/python-json-pointer";
    license = lib.licenses.bsd2; # "Modified BSD license, says pypi"
  };
}
