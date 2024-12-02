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

  # optional-dependencies
  coreapi,
  coreschema,
  django-guardian,
  inflection,
  psycopg2,
  pygments,
  pyyaml,

  # tests
  pytestCheckHook,
  pytest-django,
}:

buildPythonPackage rec {
  pname = "djangorestframework";
  version = "3.15.2";
  pyproject = true;
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "encode";
    repo = "django-rest-framework";
    rev = version;
    hash = "sha256-ne0sk4m11Ha77tNmCsdhj7QVmCkYj5GjLn/dLF4qxU8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    django
    pygments
  ] ++ (lib.optional (lib.versionOlder django.version "5.0.0") pytz);

  optional-dependencies = {
    complete = [
      coreapi
      coreschema
      django-guardian
      inflection
      psycopg2
      pygments
      pyyaml
    ];
  };

  nativeCheckInputs = [
    pytest-django
    pytestCheckHook
  ] ++ optional-dependencies.complete;

  disabledTests = [
    # https://github.com/encode/django-rest-framework/issues/9422
    "test_urlpatterns"
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
