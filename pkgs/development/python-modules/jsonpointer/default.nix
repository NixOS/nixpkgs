{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "jsonpointer";
  version = "3.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Ky1ynyCRUi1hw7MfguEYcPYLaPQ/vHBct2v0uDKvWe8=";
  };

  meta = with lib; {
    description = "Resolve JSON Pointers in Python";
    mainProgram = "jsonpointer";
    homepage = "https://github.com/stefankoegl/python-json-pointer";
    license = licenses.bsd2; # "Modified BSD license, says pypi"
  };
}
