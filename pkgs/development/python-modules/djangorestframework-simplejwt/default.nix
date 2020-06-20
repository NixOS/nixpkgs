{ lib, buildPythonPackage, fetchPypi, django, djangorestframework, pyjwt }:

buildPythonPackage rec {
  pname = "djangorestframework_simplejwt";
  version = "4.4.0";
  
  src = fetchPypi {
    inherit pname version;
    sha256 = "c315be70aa12a5f5790c0ab9acd426c3a58eebea65a77d0893248c5144a5080c";
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
