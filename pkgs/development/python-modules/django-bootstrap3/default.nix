{ lib
, buildPythonPackage
<<<<<<< HEAD
, fetchFromGitHub

# build-system
, hatchling

# non-propagates
, django

# tests
=======
, fetchPypi
, setuptools
, django
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pytest-django
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "django-bootstrap3";
<<<<<<< HEAD
  version = "23.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "zostera";
    repo = "django-bootstrap3";
    rev = "refs/tags/v${version}";
    hash = "sha256-1/JQ17GjBHH0JbY4EnHOS2B3KhEJdG2yL6O2nc1HNNc=";
  };

  postPatch = ''
    sed -i '/beautifulsoup4/d' pyproject.toml
  '';

  nativeBuildInputs = [
    hatchling
=======
  version = "23.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cJW3xmqJ87rreOoCh5nr15XSlzn8hgJGBCLnwqGUrTA=";
  };

  nativeBuildInputs = [
    setuptools
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  buildInputs = [
    django
  ];

  pythonImportsCheck = [
    "bootstrap3"
  ];

  nativeCheckInputs = [
    pytest-django
    pytestCheckHook
  ];

  env.DJANGO_SETTINGS_MODULE = "tests.app.settings";

  meta = with lib; {
    description = "Bootstrap 3 integration for Django";
    homepage = "https://github.com/zostera/django-bootstrap3";
<<<<<<< HEAD
    changelog = "https://github.com/zostera/django-bootstrap3/blob/v${version}/CHANGELOG.md";
=======
    changelog = "https://github.com/zostera/django-bootstrap3/blob/${version}/CHANGELOG.md";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.bsd3;
    maintainers = with maintainers; [ hexa ];
  };
}


