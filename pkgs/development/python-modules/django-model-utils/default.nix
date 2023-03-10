{ lib
, buildPythonPackage
, fetchFromGitHub
, django
, freezegun
, psycopg2
, pytest-django
, pytestCheckHook
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "django-model-utils";
  version = "4.2.0";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "django-model-utils";
    rev = version;
    sha256 = "sha256-TLqvpP/ZaGGFdqnN+UHbhXv1K1YVYTYBkCiWCjYrFh8=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    django
  ];

  # requires postgres database
  doCheck = false;

  nativeCheckInputs = [
    freezegun
    psycopg2
    pytest-django
    pytestCheckHook
  ];

  pythonImportsCheck = [ "model_utils" ];

  meta = with lib; {
    homepage = "https://github.com/jazzband/django-model-utils";
    description = "Django model mixins and utilities";
    license = licenses.bsd3;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
