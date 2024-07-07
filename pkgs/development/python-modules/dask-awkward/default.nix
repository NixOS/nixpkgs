{
  lib,
  awkward,
  buildPythonPackage,
  cachetools,
  dask,
  dask-histogram,
  distributed,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  hist,
  pandas,
  pyarrow,
  pytestCheckHook,
  pythonOlder,
  pythonRelaxDepsHook,
  typing-extensions,
  uproot,
}:

buildPythonPackage rec {
  pname = "dask-awkward";
  version = "2024.6.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "dask-contrib";
    repo = "dask-awkward";
    rev = "refs/tags/${version}";
    hash = "sha256-m/KvPo4IGn19sA5RcA/+OhLMCDBU+9BbMQtK3gHOoEc=";
  };

  pythonRelaxDeps = [ "awkward" ];

  build-system = [
    hatch-vcs
    hatchling
    pythonRelaxDepsHook
  ];

  dependencies = [
    awkward
    cachetools
    dask
    typing-extensions
  ];

  passthru.optional-dependencies = {
    io = [ pyarrow ];
  };

  checkInputs = [
    dask-histogram
    distributed
    hist
    pandas
    pytestCheckHook
    uproot
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  pythonImportsCheck = [ "dask_awkward" ];

  disabledTests = [
    # Tests require network access
    "test_remote_double"
    "test_remote_single"
    "test_from_text"
    # ValueError: not a ROOT file: first four bytes...
    "test_basic_root_works"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Native Dask collection for awkward arrays, and the library to use it";
    homepage = "https://github.com/dask-contrib/dask-awkward";
    changelog = "https://github.com/dask-contrib/dask-awkward/releases/tag/${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
