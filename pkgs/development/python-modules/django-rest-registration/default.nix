{
  lib,
  buildPythonPackage,
  django,
  djangorestframework,
  fetchFromGitHub,
  pytest-django,
  pytestCheckHook,
  pythonOlder,
  jwt,
  setuptools,
}:

buildPythonPackage rec {
  pname = "django-rest-registration";
  version = "0.9.0";
  pyproject = true;

  build-system = [ setuptools ];

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "apragacz";
    repo = "django-rest-registration";
    rev = "refs/tags/v${version}";
    hash = "sha256-EaS1qN7GpfPPeSLwwQdVWSRO2dv0DG5LD7vnXckz4Bg=";
  };

  dependencies = [
    django
    djangorestframework
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-django
    jwt
  ];

  pythonImportsCheck = [ "rest_registration" ];

  disabledTests = [
    # This test fails on Python 3.10
    "test_convert_html_to_text_fails"
    # This test is broken and was removed after 0.7.3. Remove this line once version > 0.7.3
    "test_coreapi_autoschema_success"
  ];

  meta = {
    description = "User-related REST API based on the awesome Django REST Framework";
    homepage = "https://github.com/apragacz/django-rest-registration/";
    changelog = "https://github.com/apragacz/django-rest-registration/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sephi ];
  };
}
