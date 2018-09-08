{ lib
, buildPythonPackage
, fetchPypi
, django
}:

buildPythonPackage rec {
  pname = "django-multiselectfield";
  version = "0.1.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "52483d23aecbf6b502f9e6806e97da9288d5d7f2a3f99f736390763de68c8fd7";
  };

  propagatedBuildInputs = [ django ];

  # No tests
  doCheck = false;

  meta = {
    description = "django-multiselectfield";
    homepage = https://github.com/goinnn/django-multiselectfield;
    license = lib.licenses.lgpl3;
  };
}