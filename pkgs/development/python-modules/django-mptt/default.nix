{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  django,
  django-js-asset,
  model-bakery,
  pytestCheckHook,
  pytest-django,
}:

buildPythonPackage rec {
  pname = "django-mptt";
  version = "0.18";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django-mptt";
    repo = "django-mptt";
    rev = version;
    hash = "sha256-UJQwjOde0DkG/Pa/pd2htnp4KEn5KwYAo8GP5A7/h+I=";
  };

  build-system = [ hatchling ];

  dependencies = [
    django
    django-js-asset
  ];

  pythonImportsCheck = [ "mptt" ];

  nativeCheckInputs = [
    model-bakery
    pytestCheckHook
    pytest-django
  ];

  preCheck = ''
    export DJANGO_SETTINGS_MODULE=tests.settings
    export PYTHONPATH=$(pwd)/tests:$PYTHONPATH
  '';

  meta = with lib; {
    description = "Utilities for implementing a modified pre-order traversal tree in Django";
    homepage = "https://github.com/django-mptt/django-mptt";
    maintainers = with maintainers; [ hexa ];
    license = with licenses; [ mit ];
  };
}
