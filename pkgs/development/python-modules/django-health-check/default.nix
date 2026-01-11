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
  version = "3.20.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "KristianOellegaard";
    repo = "django-health-check";
    tag = version;
    hash = "sha256-voB3shugfM/nO0vPd9yA4NOUB+E9aVcFnqG1mtfRYFc=";
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

  meta = {
    description = "Pluggable app that runs a full check on the deployment";
    homepage = "https://github.com/KristianOellegaard/django-health-check";
    changelog = "https://github.com/revsys/django-health-check/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ onny ];
  };
}
