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
  version = "4.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "django-model-utils";
    rev = "refs/tags/${version}";
    hash = "sha256-/9gLovZGUwdoz3o3LZBfQ7iWr95cpTWq2YqFKoQC9kY=";
  };

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
    changelog = "https://github.com/jazzband/django-model-utils/blob/${version}/CHANGES.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
