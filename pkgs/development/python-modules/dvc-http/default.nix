{ lib
, aiohttp-retry
, buildPythonPackage
, fetchFromGitHub
, dvc-objects
, fsspec
, pythonOlder
, pythonRelaxDepsHook
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "dvc-http";
  version = "2.30.2";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-IlgJEnS+rHSg5cw7SCc3vVtG1mJA5voGViya7nkpL2M=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    dvc-objects
    fsspec
    aiohttp-retry
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
