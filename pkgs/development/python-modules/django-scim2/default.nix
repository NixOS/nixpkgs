{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # propagates
  django,
  scim2-filter-parser,

  # tests
  mock,
  pytest-django,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "django-scim2";
  version = "0.20.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "15five";
    repo = "django-scim2";
    tag = version;
    hash = "sha256-OsfC6Jc/oQl6nzy3Nr3vkY+XicRxUoV62hK8MHa3LJ8=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    django
    scim2-filter-parser
  ];

  pythonImportsCheck = [ "django_scim" ];

  nativeCheckInputs = [
    mock
    pytest-django
    pytestCheckHook
  ];

  meta = with lib; {
    changelog = "https://github.com/15five/django-scim2/blob/${src.tag}/CHANGES.txt";
    description = "SCIM 2.0 Service Provider Implementation (for Django)";
    homepage = "https://github.com/15five/django-scim2";
    license = licenses.mit;
    maintainers = with maintainers; [ s1341 ];
  };
}
