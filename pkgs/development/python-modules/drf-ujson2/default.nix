{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  setuptools,

  # dependencies
  django,
  djangorestframework,
  ujson,

  # tests
  pytest-cov-stub,
  pytest-django,
  pytest-mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "drf-ujson2";
  version = "1.8.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "Amertz08";
    repo = "drf_ujson2";
    tag = "v${version}";
    hash = "sha256-NtloZWsEmRbPl7pdxPQqpzIzTyyOEFO9KtZ60F7VuUQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    django
    djangorestframework
    ujson
  ];

  env.DJANGO_SETTINGS_MODULE = "tests.settings";

  nativeCheckInputs = [
    pytest-cov-stub
    pytest-django
    pytest-mock
    pytestCheckHook
  ];

  meta = with lib; {
    changelog = "https://github.com/Amertz08/drf_ujson2/releases/tag/v${version}";
    description = "JSON parser and renderer using ujson for Django Rest Framework";
    homepage = "https://github.com/Amertz08/drf_ujson2";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
