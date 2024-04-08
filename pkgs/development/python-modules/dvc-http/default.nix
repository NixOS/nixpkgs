{ lib
, aiohttp-retry
, buildPythonPackage
, fetchFromGitHub
, dvc-objects
, fsspec
, funcy
, pythonOlder
, pythonRelaxDepsHook
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "dvc-http";
  version = "2.32.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = "dvc-http";
    rev = "refs/tags/${version}";
    hash = "sha256-ru/hOFv/RcS/7SBpTJU8xFxdllmaiH4dV1ouS6GGKkY=";
  };

  build-system = [
    setuptools-scm
  ];

  dependencies = [
    aiohttp-retry
    dvc-objects
    fsspec
    funcy
  ];

  # Currently it's not possible to run the tests
  # ModuleNotFoundError: No module named 'dvc.testing'
  doCheck = false;

  pythonImportsCheck = [
    "dvc_http"
  ];

  meta = with lib; {
    description = "HTTP plugin for dvc";
    homepage = "https://github.com/iterative/dvc-http";
    changelog = "https://github.com/iterative/dvc-http/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
