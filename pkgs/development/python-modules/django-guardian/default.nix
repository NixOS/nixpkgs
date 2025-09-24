{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django-environ,
  django,
  pytestCheckHook,
  pytest-django,
  setuptools,
}:

buildPythonPackage rec {
  pname = "django-guardian";
  version = "3.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django-guardian";
    repo = "django-guardian";
    tag = version;
    hash = "sha256-fiC3IGZwQbSCz6vVJXdSd2BpELEiYfKW1vsf+6xL4ck=";
  };

  build-system = [ setuptools ];

  dependencies = [ django ];

  nativeCheckInputs = [
    django-environ
    pytestCheckHook
    pytest-django
  ];

  pythonImportsCheck = [ "guardian" ];

  meta = with lib; {
    description = "Per object permissions for Django";
    homepage = "https://github.com/django-guardian/django-guardian";
    license = with licenses; [ bsd2 ];
    maintainers = [ ];
  };
}
