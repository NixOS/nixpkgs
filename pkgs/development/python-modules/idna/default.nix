{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "idna";
  version = "2.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3cb5ce08046c4e3a560fc02f138d0ac63e00f8ce5901a56b32ec8b7994082aab";
  };

  meta = {
    homepage = "http://github.com/kjd/idna/";
    description = "Internationalized Domain Names in Applications (IDNA)";
    license = lib.licenses.bsd3;
  };
}