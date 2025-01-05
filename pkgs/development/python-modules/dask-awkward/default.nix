{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatch-vcs,
  hatchling,

  # dependencies
  awkward,
  cachetools,
  dask,
  typing-extensions,

  # optional-dependencies
  pyarrow,

  # checks
  dask-histogram,
  distributed,
  hist,
  pandas,
  pytestCheckHook,
  uproot,
}:

buildPythonPackage rec {
  pname = "dask-awkward";
  version = "2024.12.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dask-contrib";
    repo = "dask-awkward";
    tag = version;
    hash = "sha256-pL1LDW/q78V/c3Bha38k40018MFO+i8X6htYNdcsy7s=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    awkward
    cachetools
    dask
    typing-extensions
  ];

  optional-dependencies = {
    io = [ pyarrow ];
  };

  checkInputs = [
    dask-histogram
    distributed
    hist
    pandas
    pytestCheckHook
    uproot
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "dask_awkward" ];

  disabledTests = [
    # Tests require network access
    "test_remote_double"
    "test_remote_single"
    "test_from_text"
    # ValueError: not a ROOT file: first four bytes...
    "test_basic_root_works"
    # Flaky. https://github.com/dask-contrib/dask-awkward/issues/506.
    "test_distance_behavior"
  ];

  disabledTestPaths = [
    # TypeError: Blockwise.__init__() got an unexpected keyword argument 'dsk'
    # https://github.com/dask-contrib/dask-awkward/issues/557
    "tests/test_str.py"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Native Dask collection for awkward arrays, and the library to use it";
    homepage = "https://github.com/dask-contrib/dask-awkward";
    changelog = "https://github.com/dask-contrib/dask-awkward/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
