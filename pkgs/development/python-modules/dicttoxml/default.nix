{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "dicttoxml";
  version = "1.7.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ea44cc4ec6c0f85098c57a431a1ee891b3549347b07b7414c8a24611ecf37e45";
  };

  # No tests in archive
  doCheck = false;

  meta = {
    description = "Converts a Python dictionary or other native data type into a valid XML string";
    homepage = https://github.com/quandyfactory/dicttoxml;
    license = lib.licenses.gpl2;
  };
}