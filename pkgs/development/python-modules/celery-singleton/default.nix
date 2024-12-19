{
  lib,
  buildPythonPackage,
  fetchpatch,
  fetchFromGitHub,
  poetry-core,
  celery,
  redis,
  pytestCheckHook,
  pytest-celery,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "celery-singleton";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "steinitzu";
    repo = "celery-singleton";
    rev = version;
    hash = "sha256-fHlakxxjYIADELZdxIj6rvsZ/+1QfnKvAg3w5cdzvDc=";
  };

  patches = [
    # chore(poetry): use poetry-core
    # https://github.com/steinitzu/celery-singleton/pull/54
    (fetchpatch {
      name = "use-poetry-core.patch";
      url = "https://github.com/steinitzu/celery-singleton/pull/54/commits/634a001c92a1dff1fae513fc95d733ea9b87e4cf.patch";
      hash = "sha256-lXN4khwyL96pWyBS+iuSkGEkegv4HxYtym+6JUcPa94=";
    })
  ];

  build-system = [ poetry-core ];

  dependencies = [
    celery
    redis
  ];

  checkInputs = [
    pytestCheckHook
    pytest-celery
    pytest-cov-stub
  ];

  pytestFlagsArray = [ "tests" ];

  # Tests require a running Redis backend
  disabledTests = [
    "TestLock"
    "TestUnlock"
    "TestClear"
    "TestSimpleTask"
    "TestRaiseOnDuplicateConfig"
    "TestUniqueOn"
  ];

  pythonImportsCheck = [ "celery_singleton" ];

  meta = with lib; {
    description = "Seamlessly prevent duplicate executions of celery tasks";
    homepage = "https://github.com/steinitzu/celery-singleton";
    changelog = "https://github.com/steinitzu/celery-singleton/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
