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
  version = "4.10.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "adamchainz";
    repo = "django-mysql";
    rev = "refs/tags/${version}";
    hash = "sha256-5RmNYOY0m6BRD/3cENQLWPJ+dElR53oZaqk616kfQTA=";
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
    changelog = "https://github.com/adamchainz/django-mysql/blob/${version}/docs/changelog.rst";
    description = "Extensions to Django for use with MySQL/MariaD";
    homepage = "https://github.com/adamchainz/django-mysql";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
