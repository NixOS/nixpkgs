{ lib
, buildPythonPackage
<<<<<<< HEAD
, cryptography
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
  version = "5.3.0";
=======
  version = "5.2.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "djangorestframework_simplejwt";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-jkxd/KjRHAuKZt/YpOP8HGqn6hiNEJB/+RyUL0tS7WY=";
=======
    hash = "sha256-0n1LysLGOU9njeqLTQ1RHG4Yp/Lriq7rin3mAa63fEI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    django
    djangorestframework
    pyjwt
<<<<<<< HEAD
  ];

  passthru.optional-dependencies = {
    python-jose = [
      python-jose
    ];
    crypto = [
      cryptography
    ];
  };

=======
    python-jose
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  # Test raises django.core.exceptions.ImproperlyConfigured
  doCheck = false;

  pythonImportsCheck = [
    "rest_framework_simplejwt"
  ];

  meta = with lib; {
    description = "JSON Web Token authentication plugin for Django REST Framework";
    homepage = "https://github.com/davesque/django-rest-framework-simplejwt";
<<<<<<< HEAD
    changelog = "https://github.com/jazzband/djangorestframework-simplejwt/blob/v${version}/CHANGELOG.md";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ arnoldfarkas ];
  };
}
