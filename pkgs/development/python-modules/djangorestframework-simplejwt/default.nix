{ lib
, buildPythonPackage
, django
, djangorestframework
, fetchPypi
, pyjwt
, python-jose
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "djangorestframework-simplejwt";
  version = "5.1.0";

  src = fetchPypi {
    pname = "djangorestframework_simplejwt";
    inherit version;
    sha256 = "sha256-dTI1KKe5EIQ7h5GUdG8OvDSBxK2fNU3i3RYhYGYvuVo=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    django
    djangorestframework
    pyjwt
    python-jose
  ];

  # Test raises django.core.exceptions.ImproperlyConfigured
  doCheck = false;

  pythonImportsCheck = [
    "rest_framework_simplejwt"
  ];

  meta = with lib; {
    description = "JSON Web Token authentication plugin for Django REST Framework";
    homepage = "https://github.com/davesque/django-rest-framework-simplejwt";
    license = licenses.mit;
    maintainers = with maintainers; [ arnoldfarkas ];
  };
}
