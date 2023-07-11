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
  version = "4.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "django-model-utils";
    rev = "refs/tags/${version}";
    hash = "sha256-p3/JO6wNwZPYX7MIgMj/0caHt5s+uL51Sxa28/VITxo=";
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
    changelog = "https://github.com/jazzband/django-model-utils/blob/${version}/CHANGES.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
