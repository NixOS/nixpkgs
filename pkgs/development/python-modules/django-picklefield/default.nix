{ lib, buildPythonPackage, fetchPypi, django }:

buildPythonPackage rec {
  pname = "django-picklefield";
  version = "2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f1733a8db1b6046c0d7d738e785f9875aa3c198215de11993463a9339aa4ea24";
  };

  propagatedBuildInputs = [ django ];

  meta = {
    description = "A pickled object field for Django";
    homepage = https://github.com/gintas/django-picklefield;
    license = lib.licenses.mit;
  };
}
