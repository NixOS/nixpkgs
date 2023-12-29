{ lib
, buildPythonPackage
, fetchFromGitHub
, django
, setuptools
, pytestCheckHook
, pytest-django
, mock
, nose
}:

buildPythonPackage rec {
  pname = "django-crontab";
  version = "0.7.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "kraiz";
    repo = "django-crontab";
    rev = "refs/tags/${version}";
    hash = "sha256-qX+N3SMUyhMWoWluRCeOPGYKCMBnjg61P281HXHkfJk=";
  };

  propagatedBuildInputs = [
    django
    setuptools
  ];

  nativeCheckInputs = [
    django
    mock
    nose
    pytestCheckHook
    pytest-django
  ];

  # Tests currently fail with: RuntimeError: setup_test_environment() was
  # already called and can't be called again without first calling
  # teardown_test_environment()
  doCheck = false;

  DJANGO_SETTINGS_MODULE = "tests.settings";

  pythonImportsCheck = [ "django_crontab" ];

  meta = with lib; {
    description = "Simple crontab powered job scheduling for Django";
    homepage = "https://github.com/kraiz/django-crontab";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
