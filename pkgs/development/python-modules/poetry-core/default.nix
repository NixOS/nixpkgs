{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "poetry-core";
  version = "1.0.0a9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f08e9829fd06609ca5615faa91739b589eb71e025a6aaf7ddffb698676eb7c8c";
  };

  doCheck = false; # No tests in sdist.

  meta = {
    description = "Core utilities for Poetry";
    homepage = "https://github.com/python-poetry/core";
    license = lib.licenses.mit;
  };
}