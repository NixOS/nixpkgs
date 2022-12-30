{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools-scm
, kombu
, shortuuid
, celery
, funcy
, pytest-celery
, pytest-mock
, pytest-test-utils
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "dvc-task";
  version = "0.1.9";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-+v1M8bKcHWUTz4DJ85tB1qdFYKI0k8TS/Dvf166o920=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    kombu
    shortuuid
    celery
    funcy
  ];

  checkInputs = [
    pytest-celery
    pytest-mock
    pytest-test-utils
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "dvc_task"
  ];

  meta = with lib; {
    description = "Celery task queue used in DVC";
    homepage = "https://github.com/iterative/dvc-task";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
