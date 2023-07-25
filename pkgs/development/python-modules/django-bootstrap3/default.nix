{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, django
, pytest-django
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "django-bootstrap3";
  version = "23.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cJW3xmqJ87rreOoCh5nr15XSlzn8hgJGBCLnwqGUrTA=";
  };

  nativeBuildInputs = [
    setuptools
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
    changelog = "https://github.com/zostera/django-bootstrap3/blob/${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ hexa ];
  };
}


