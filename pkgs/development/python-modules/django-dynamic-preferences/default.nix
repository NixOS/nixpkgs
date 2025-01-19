{
  lib,
  buildPythonPackage,
  distutils,
  django,
  djangorestframework,
  fetchFromGitHub,
  persisting-theory,
  pytest-django,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "django-dynamic-preferences";
  version = "1.17.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "agateblue";
    repo = "django-dynamic-preferences";
    tag = version;
    hash = "sha256-irnwoWqQQxPueglI86ZIOt8wZcEHneY3eyATBXOuk9Y=";
  };

  build-system = [
    setuptools
    distutils
  ];

  buildInputs = [ django ];

  dependencies = [ persisting-theory ];

  nativeCheckInputs = [
    djangorestframework
    pytestCheckHook
    pytest-django
  ];

  pythonImportsCheck = [ "dynamic_preferences" ];

  env.DJANGO_SETTINGS = "tests.settings";

  meta = with lib; {
    description = "Dynamic global and instance settings for your django project";
    changelog = "https://github.com/agateblue/django-dynamic-preferences/blob/${version}/HISTORY.rst";
    homepage = "https://github.com/agateblue/django-dynamic-preferences";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mmai ];
  };
}
