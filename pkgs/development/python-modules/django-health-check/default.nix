{
  lib,
  boto3,
  buildPythonPackage,
  celery,
  django-storages,
  django,
  fetchFromGitHub,
  flit-core,
  flit-scm,
  gitMinimal,
  mock,
  pytest-cov-stub,
  pytest-django,
  pytestCheckHook,
  redis,
  sphinx,
}:

buildPythonPackage rec {
  pname = "django-health-check";
  version = "3.20.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "KristianOellegaard";
    repo = "django-health-check";
    tag = version;
    hash = "sha256-qgABCDWKGYZ67sKvCozUQfmYcKWMpEVNLxInTnIaojk=";
  };

  build-system = [
    flit-core
    flit-scm
  ];

  buildInputs = [
    sphinx
    django
  ];

  nativeBuildInputs = [ gitMinimal ];

  nativeCheckInputs = [
    boto3
    django-storages
    pytest-cov-stub
    pytest-django
    pytestCheckHook
    mock
    celery
    redis
  ];

  disabledTests = [
    # commandline output mismatch
    "test_command_with_non_existence_subset"
  ];

  pythonImportsCheck = [ "health_check" ];

  meta = with lib; {
    description = "Pluggable app that runs a full check on the deployment";
    homepage = "https://github.com/KristianOellegaard/django-health-check";
    changelog = "https://github.com/revsys/django-health-check/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
