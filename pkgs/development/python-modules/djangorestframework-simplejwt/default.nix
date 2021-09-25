{ lib, buildPythonPackage, fetchPypi, django, djangorestframework, pyjwt }:

buildPythonPackage rec {
  pname = "djangorestframework_simplejwt";
  version = "4.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "153c973c5c154baf566be431de8527c2bd62557fde7373ebcb0f02b73b28e07a";
  };

  propagatedBuildInputs = [ django djangorestframework pyjwt ];

  # Test raises django.core.exceptions.ImproperlyConfigured
  doCheck = false;

  meta = with lib; {
    description = "A minimal JSON Web Token authentication plugin for Django REST Framework";
    homepage = "https://github.com/davesque/django-rest-framework-simplejwt";
    license = licenses.mit;
    maintainers = [ maintainers.arnoldfarkas ];
  };
}
