{ lib, buildPythonPackage, fetchPypi, django }:

buildPythonPackage rec {
  pname = "django-picklefield";
  version = "2.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0imncys5s3vsy2q79nn7k5d670da1xgmcr9gmhn06fry6ibf39b7";
  };

  propagatedBuildInputs = [ django ];

  meta = {
    description = "A pickled object field for Django";
    homepage = https://github.com/gintas/django-picklefield;
    license = lib.licenses.mit;
  };
}
