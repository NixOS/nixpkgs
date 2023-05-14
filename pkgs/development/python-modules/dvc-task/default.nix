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
  version = "0.2.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-DIjS56QDdjH8lp8yZE8UIccOM+OoafJK3DWZ1d/q29k=";
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
