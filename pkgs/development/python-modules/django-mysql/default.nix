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
  version = "4.9.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "adamchainz";
    repo = "django-mysql";
    rev = "refs/tags/${version}";
    hash = "sha256-mXAdwNqSIrWMh+YcCjksiqmkLSXGAd+ofyzJmiG+gNo=";
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
    changelog = "https://django-mysql.readthedocs.io/en/latest/changelog.html";
    description = "Extensions to Django for use with MySQL/MariaD";
    homepage = "https://github.com/adamchainz/django-mysql";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
