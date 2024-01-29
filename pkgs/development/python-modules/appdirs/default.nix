{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "appdirs";
  version = "1.4.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41";
  };

  meta = {
    description = "A python module for determining appropriate platform-specific dirs";
    homepage = "https://github.com/ActiveState/appdirs";
    license = lib.licenses.mit;
  };
}
