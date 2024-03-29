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
  version = "0.4.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-zSPv+eMGSsGXKtgi9r4EiGY1ZURXeJXWBKvR2GnfP8I=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    kombu
    shortuuid
    celery
    funcy
  ];

  nativeCheckInputs = [
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
    changelog = "https://github.com/iterative/dvc-task/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
