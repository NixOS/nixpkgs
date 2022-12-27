{ lib
, fetchFromGitHub
, buildPythonPackage
, python
, pytestCheckHook
, django
, djangorestframework
, pytest-django
}:

buildPythonPackage rec {
  pname = "django-rest-registration";
  version = "0.7.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "apragacz";
    repo = pname;
    rev = version;
    sha256 = "sha256-JoIeVjl5s60ilq9kU28Jo+GaYRKU61hoqy1GzYmMdZQ=";
  };

  propagatedBuildInputs = [ django djangorestframework ];

  checkInputs = [ pytestCheckHook pytest-django ];

  pythonImportsCheck = [ "rest_registration" ];

  disabledTests = [
    # This test fails on Python 3.10
    "test_convert_html_to_text_fails"
    # This test is broken and was removed after 0.7.3. Remove this line once version > 0.7.3
    "test_coreapi_autoschema_success"
  ];

  meta = with lib; {
    description = "User-related REST API based on the awesome Django REST Framework";
    homepage = "https://github.com/apragacz/django-rest-registration/";
    license = licenses.mit;
    maintainers = with maintainers; [ sephi ];
  };
}
