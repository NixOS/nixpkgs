{ lib
, buildPythonPackage
, django
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "django-webpack-loader";
<<<<<<< HEAD
  version = "2.0.1";
=======
  version = "1.8.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-Do37L82znb/QG+dgPAYBMqRmT0g4Ec48dfLTwNOat2I=";
=======
    hash = "sha256-BzvtoY4pKfpc2DuvvKr5deWUXoShe/qBkny2yfWhe5Q=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    django
  ];

  # django.core.exceptions.ImproperlyConfigured (path issue with DJANGO_SETTINGS_MODULE?)
  doCheck = false;

  pythonImportsCheck = [
    "webpack_loader"
  ];

  meta = with lib; {
    description = "Use webpack to generate your static bundles";
    homepage = "https://github.com/owais/django-webpack-loader";
<<<<<<< HEAD
    changelog = "https://github.com/django-webpack/django-webpack-loader/blob/${version}/CHANGELOG.md";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ peterromfeldhk ];
  };
}
