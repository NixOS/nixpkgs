{ lib
, buildPythonPackage
, django
, djangorestframework
, fetchFromGitHub
, pytest-django
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "django-rest-registration";
  version = "0.8.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "apragacz";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-RDegK+1A01kfpit3LX+ToViqPlTiZ3dIve38ea7lNxE=";
  };

  propagatedBuildInputs = [
    django
    djangorestframework
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-django
  ];

  pythonImportsCheck = [
    "rest_registration"
  ];

  disabledTests = [
    # This test fails on Python 3.10
    "test_convert_html_to_text_fails"
    # This test is broken and was removed after 0.7.3. Remove this line once version > 0.7.3
    "test_coreapi_autoschema_success"
  ];

  meta = with lib; {
    description = "User-related REST API based on the awesome Django REST Framework";
    homepage = "https://github.com/apragacz/django-rest-registration/";
    changelog = "https://github.com/apragacz/django-rest-registration/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ sephi ];
  };
}
