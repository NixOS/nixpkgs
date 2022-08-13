{ lib
, aiohttp-retry
, buildPythonPackage
, dvc
, fetchFromGitHub
, fsspec
, pythonOlder
, pythonRelaxDepsHook
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "dvc-http";
  version = "0.0.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = pname;
    rev = version;
    hash = "sha256-lZctTmMMF9OMvzMbTYH1d/twW284/IcO8ICb/ennFQA=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    pythonRelaxDepsHook
    setuptools-scm
  ];

  propagatedBuildInputs = [
    dvc
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
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
