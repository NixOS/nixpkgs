{ lib
, buildPythonPackage
, fetchPypi
, unittest2
}:

buildPythonPackage rec {
  pname = "contextlib2";
  version = "21.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ab1e2bfe1d01d968e1b7e8d9023bc51ef3509bba217bb730cee3827e1ee82869";
  };

  checkInputs = [ unittest2 ];

  meta = {
    description = "Backports and enhancements for the contextlib module";
    homepage = "https://contextlib2.readthedocs.org/";
    license = lib.licenses.psfl;
  };
}
