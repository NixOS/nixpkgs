{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "django-picklefield";
  version = "1.0.0";

  meta = {
    description = "A pickled object field for Django";
    homepage = https://github.com/gintas/django-picklefield;
    license = lib.licenses.mit;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "61e3ba7f6df82d8df9e6be3a8c55ef589eb3bf926c3d25d2b7949b07eae78354";
  };
}
