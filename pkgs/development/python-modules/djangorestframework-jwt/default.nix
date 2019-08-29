{ lib
, fetchPypi
, django
, pyjwt
, djangorestframework
, buildPythonPackage
}:

buildPythonPackage rec {
  pname = "djangorestframework-jwt";
  version = "1.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "19rng6v1sw14mbjp5cplnrgxjnhlj8faalfw02iihi9s5w1k7zjy";
  };

  propagatedBuildInputs = [ pyjwt django djangorestframework ];

  # ./runtests.py fails because the project must be tested against a django
  # installation, there are missing database tables for User, that don't exist.
  doCheck = false;

  meta = with lib; {
    description = "JSON Web Token Authentication support for Django REST Framework";
    homepage = https://github.com/GetBlimp/django-rest-framework-jwt;
    license = licenses.mit;
    maintainers = [ maintainers.ivegotasthma ];
  };
}
