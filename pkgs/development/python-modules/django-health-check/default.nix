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
<<<<<<< HEAD
  version = "3.20.8";
=======
  version = "3.20.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "KristianOellegaard";
    repo = "django-health-check";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-voB3shugfM/nO0vPd9yA4NOUB+E9aVcFnqG1mtfRYFc=";
=======
    hash = "sha256-qgABCDWKGYZ67sKvCozUQfmYcKWMpEVNLxInTnIaojk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Pluggable app that runs a full check on the deployment";
    homepage = "https://github.com/KristianOellegaard/django-health-check";
    changelog = "https://github.com/revsys/django-health-check/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ onny ];
=======
  meta = with lib; {
    description = "Pluggable app that runs a full check on the deployment";
    homepage = "https://github.com/KristianOellegaard/django-health-check";
    changelog = "https://github.com/revsys/django-health-check/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
