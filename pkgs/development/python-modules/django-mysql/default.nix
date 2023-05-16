{ lib
, buildPythonPackage
, fetchFromGitHub

# build-system
, setuptools

# dependencies
, django
, mysqlclient

# tests
, pytest-django
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "django-mysql";
<<<<<<< HEAD
  version = "4.11.0";
=======
  version = "4.9.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "adamchainz";
    repo = "django-mysql";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-4PxJH5P/a4oNigbTjrZa3q+FeDQTdkvCKonUUl4I8m0=";
=======
    hash = "sha256-mXAdwNqSIrWMh+YcCjksiqmkLSXGAd+ofyzJmiG+gNo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    setuptools
  ];

  buildInputs = [
    django
    mysqlclient
  ];

  doCheck = false; # requires mysql/mariadb server

  env.DJANGO_SETTINGS_MODULE = "tests.settings";

  nativeCheckInputs = [
    pytest-django
    pytestCheckHook
  ];

  meta = with lib; {
<<<<<<< HEAD
    changelog = "https://github.com/adamchainz/django-mysql/blob/${version}/docs/changelog.rst";
=======
    changelog = "https://django-mysql.readthedocs.io/en/latest/changelog.html";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "Extensions to Django for use with MySQL/MariaD";
    homepage = "https://github.com/adamchainz/django-mysql";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
