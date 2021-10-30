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
  version = "4.8.0";

  src = fetchPypi {
    pname = "djangorestframework_simplejwt";
    inherit version;
    sha256 = "153c973c5c154baf566be431de8527c2bd62557fde7373ebcb0f02b73b28e07a";
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
