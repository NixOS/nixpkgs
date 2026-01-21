{
  lib,
  buildPythonPackage,
  django,
  djangorestframework,
  fetchFromGitHub,
  pytest-django,
  pytest-xdist,
  pytestCheckHook,
  pyjwt,
  setuptools,
}:

buildPythonPackage rec {
  pname = "django-rest-registration";
  version = "0.9.0";
  pyproject = true;

  build-system = [ setuptools ];

  src = fetchFromGitHub {
    owner = "apragacz";
    repo = "django-rest-registration";
    tag = "v${version}";
    hash = "sha256-EaS1qN7GpfPPeSLwwQdVWSRO2dv0DG5LD7vnXckz4Bg=";
  };

  dependencies = [
    django
    djangorestframework
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-django
    pytest-xdist
    pyjwt
  ];

  pythonImportsCheck = [ "rest_registration" ];

  disabledTests = [
    # Failed: DID NOT RAISE <class 'rest_registration.utils.html.MLStripperParseFailed'>
    "test_convert_html_to_text_fails"
  ];

  meta = {
    description = "User-related REST API based on the awesome Django REST Framework";
    homepage = "https://github.com/apragacz/django-rest-registration/";
    changelog = "https://github.com/apragacz/django-rest-registration/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sephi ];
  };
}
