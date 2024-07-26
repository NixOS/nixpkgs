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
  version = "0.3.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-nrE8PdvzhH7lO0flvNkGC61NOVT4aj2E2gKEDRkp+b4=";
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
