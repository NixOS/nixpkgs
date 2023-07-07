{ lib
, buildPythonPackage
, django
, djangorestframework
, fetchPypi
, pyjwt
, python-jose
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "djangorestframework-simplejwt";
  version = "5.2.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "djangorestframework_simplejwt";
    inherit version;
    hash = "sha256-0n1LysLGOU9njeqLTQ1RHG4Yp/Lriq7rin3mAa63fEI=";
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
