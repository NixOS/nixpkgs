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

  # tests
  distributed,
  hist,
  pandas,
  pytestCheckHook,
  uproot,
}:

buildPythonPackage rec {
  pname = "dask-awkward";
  version = "2025.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dask-contrib";
    repo = "dask-awkward";
    tag = version;
    hash = "sha256-z4dRGNoqwIEOwaz5U0DqCh/chZtopiLNvvvfl0bJxxI=";
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

  nativeCheckInputs = [
    # dask-histogram (circular dependency)
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

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Native Dask collection for awkward arrays, and the library to use it";
    homepage = "https://github.com/dask-contrib/dask-awkward";
    changelog = "https://github.com/dask-contrib/dask-awkward/releases/tag/${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
