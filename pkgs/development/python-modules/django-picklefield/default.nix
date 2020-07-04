{ lib, buildPythonPackage, fetchPypi, django }:

buildPythonPackage rec {
  pname = "django-picklefield";
  version = "3.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15ccba592ca953b9edf9532e64640329cd47b136b7f8f10f2939caa5f9ce4287";
  };

  propagatedBuildInputs = [ django ];

  meta = {
    description = "A pickled object field for Django";
    homepage = "https://github.com/gintas/django-picklefield";
    license = lib.licenses.mit;
  };
}
