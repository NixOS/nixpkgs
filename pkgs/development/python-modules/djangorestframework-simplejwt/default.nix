{ lib
, buildPythonPackage
, cryptography
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
  version = "5.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "djangorestframework_simplejwt";
    inherit version;
    hash = "sha256-bEvTdTdEC8Q5Vk6/fWCF50xUEUhRlwc/UI69+jS8n64=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    django
    djangorestframework
    pyjwt
  ];

  passthru.optional-dependencies = {
    python-jose = [
      python-jose
    ];
    crypto = [
      cryptography
    ];
  };

  # Test raises django.core.exceptions.ImproperlyConfigured
  doCheck = false;

  pythonImportsCheck = [
    "rest_framework_simplejwt"
  ];

  meta = with lib; {
    description = "JSON Web Token authentication plugin for Django REST Framework";
    homepage = "https://github.com/davesque/django-rest-framework-simplejwt";
    changelog = "https://github.com/jazzband/djangorestframework-simplejwt/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ arnoldfarkas ];
  };
}
