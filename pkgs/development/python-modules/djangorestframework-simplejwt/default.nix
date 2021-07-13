{ lib, buildPythonPackage, fetchPypi, django, djangorestframework, pyjwt }:

buildPythonPackage rec {
  pname = "djangorestframework_simplejwt";
  version = "4.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c0e9b617da337becb55e67935eb992fad84f861418e7ab5fb3e77a3fd18d4137";
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
