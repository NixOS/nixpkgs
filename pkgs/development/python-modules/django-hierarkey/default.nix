{ lib
, buildPythonPackage
, fetchFromGitHub

# propagates
, python-dateutil

# tests
, django-extensions
, pytest-django
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "django-hierarkey";
  version = "1.1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "raphaelm";
    repo = "django-hierarkey";
    # https://github.com/raphaelm/django-hierarkey/commit/c81ace02ca404a8756e2931bb6faf55b6365e140
    rev = "c81ace02ca404a8756e2931bb6faf55b6365e140";
    hash = "sha256-sCARyTjuuAUptlOsFmApnsQpcksP+uYnq0lukXDMcuk=";
  };

  propagatedBuildInputs = [
    python-dateutil
  ];

  pythonImportsCheck = [
    "hierarkey"
  ];

  nativeCheckInputs = [
    django-extensions
    pytest-django
    pytestCheckHook
  ];

  DJANGO_SETTINGS_MODULE = "tests.settings";

  pytestFlagsArray = [
    "tests"
  ];

  meta = with lib; {
    description = "Flexible and powerful hierarchical key-value store for your Django models";
    homepage = "https://github.com/raphaelm/django-hierarkey";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
