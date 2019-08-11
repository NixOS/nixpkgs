{ lib
, buildPythonPackage
, fetchPypi
, unittest2
}:

buildPythonPackage rec {
  pname = "contextlib2";
  version = "0.5.5";

  src = fetchPypi rec {
    inherit pname version;
    sha256 = "509f9419ee91cdd00ba34443217d5ca51f5a364a404e1dce9e8979cea969ca48";
  };

  checkInputs = [ unittest2 ];

  meta = {
    description = "Backports and enhancements for the contextlib module";
    homepage = https://contextlib2.readthedocs.org/;
    license = lib.licenses.psfl;
  };
}
