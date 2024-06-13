{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  setuptools,

  # dependencies
  django,
  pytz,

  # tests
  coreapi,
  coreschema,
  django-guardian,
  inflection,
  psycopg2,
  pytestCheckHook,
  pytest-django,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "djangorestframework";
  version = "3.15.1";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "encode";
    repo = "django-rest-framework";
    rev = version;
    hash = "sha256-G914NvxRmKGkxrozoWNUIoI74YkYRbeNcQwIG4iSeXU=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    django
    pytz
  ];

  nativeCheckInputs = [
    pytest-django
    pytestCheckHook

    # optional tests
    coreapi
    coreschema
    django-guardian
    inflection
    psycopg2
    pyyaml
  ];

  pythonImportsCheck = [ "rest_framework" ];

  meta = with lib; {
    changelog = "https://github.com/encode/django-rest-framework/releases/tag/3.15.1";
    description = "Web APIs for Django, made easy";
    homepage = "https://www.django-rest-framework.org/";
    maintainers = with maintainers; [ desiderius ];
    license = licenses.bsd2;
  };
}
