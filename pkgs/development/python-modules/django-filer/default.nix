{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pytestCheckHook,
  django-polymorphic,
  setuptools,
  python,
  easy-thumbnails,
  pillow-heif,
  django-app-helper,
  distutils,
}:

buildPythonPackage rec {
  pname = "django-filer";
<<<<<<< HEAD
  version = "3.4.1";
  pyproject = true;

=======
  version = "3.3.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "django-cms";
    repo = "django-filer";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-lbt7Tk+BJX9sesIPjZ0bIpE0RzO4nH/TAdimowfYtkA=";
=======
    hash = "sha256-EAiqGRdmUii86QwHkZ2BT5vBRaiXpNWbr9INmuYW444=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  dependencies = [
    django
    django-polymorphic
    easy-thumbnails
<<<<<<< HEAD
  ]
  ++ easy-thumbnails.optional-dependencies.svg;
=======
  ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  optional-dependencies = {
    heif = [ pillow-heif ];
  };

  checkInputs = [
    distutils
    django-app-helper
  ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} tests/settings.py
    runHook postCheck
  '';

  meta = {
<<<<<<< HEAD
    changelog = "https://github.com/django-cms/django-filer/blob/${src.tag}/CHANGELOG.rst";
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "File management application for Django";
    homepage = "https://github.com/django-cms/django-filer";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.onny ];
  };
}
