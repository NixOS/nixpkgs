{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "idna";
  version = "2.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2c6a5de3089009e3da7c5dde64a141dbc8551d5b7f6cf4ed7c2568d0cc520a8f";
  };

  meta = {
    homepage = "https://github.com/kjd/idna/";
    description = "Internationalized Domain Names in Applications (IDNA)";
    license = lib.licenses.bsd3;
  };
}