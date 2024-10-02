{
  lib,
  buildPythonPackage,
  celery,
  fetchFromGitHub,
  funcy,
  kombu,
  pytest-celery,
  pytest-mock,
  pytest-test-utils,
  pytestCheckHook,
  pythonOlder,
  setuptools-scm,
  shortuuid,
}:

buildPythonPackage rec {
  pname = "dvc-task";
  version = "0.4.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = "dvc-task";
    rev = "refs/tags/${version}";
    hash = "sha256-zSPv+eMGSsGXKtgi9r4EiGY1ZURXeJXWBKvR2GnfP8I=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    celery
    funcy
    kombu
    shortuuid
  ];

  nativeCheckInputs = [
    pytest-celery
    pytest-mock
    pytest-test-utils
    pytestCheckHook
  ];

  pythonImportsCheck = [ "dvc_task" ];

  disabledTests = [
    # Test is flaky
    "test_start_already_exists"
    # Tests require a Docker setup
    "celery_setup_worker"
  ];

  meta = with lib; {
    description = "Celery task queue used in DVC";
    homepage = "https://github.com/iterative/dvc-task";
    changelog = "https://github.com/iterative/dvc-task/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
