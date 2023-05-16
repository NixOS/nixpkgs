{ lib
, buildPythonPackage
, fetchFromGitHub
, python-dateutil
, python-mimeparse
, pythonOlder
}:

buildPythonPackage rec {
  pname = "django-tastypie";
<<<<<<< HEAD
  version = "0.14.6";
=======
  version = "0.14.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "django-tastypie";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-emZVcycGLa8Z2yMv/NWZi1b5fPk50u841cFfFF3Ke/s=";
=======
    hash = "sha256-RgYinpo8eVzRaSkcnFkSq+IqpcFt6LCCHkpHyB/7u5M=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    python-dateutil
    python-mimeparse
  ];

  # Tests requires a Django instance
  doCheck = false;

  pythonImportsCheck = [
    "tastypie"
  ];

  meta = with lib; {
    description = "Utilities and helpers for writing Pylint plugins";
    homepage = "https://github.com/django-tastypie/django-tastypie";
    changelog = "https://github.com/django-tastypie/django-tastypie/releases/tag/v${version}";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ fab ];
  };
}
