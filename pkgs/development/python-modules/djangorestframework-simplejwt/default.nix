{ lib, buildPythonPackage, fetchPypi, django, djangorestframework, pyjwt }:

buildPythonPackage rec {
  pname = "djangorestframework_simplejwt";
  version = "4.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7adc913ba0d2ed7f46e0b9bf6e86f9bd9248f1c4201722b732b8213e0ea66f9f";
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
