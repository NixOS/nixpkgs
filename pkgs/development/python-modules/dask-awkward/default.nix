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

buildPythonPackage (finalAttrs: {
  pname = "dask-awkward";
  version = "2026.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dask-contrib";
    repo = "dask-awkward";
    tag = finalAttrs.version;
    hash = "sha256-iAecPdLbg1UhHn5rZEMYbeQGSpxYWkEFjq/mxzazG3E=";
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
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

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

    # RuntimeError: Attempting to use an asynchronous Client in a synchronous context of `dask.compute`
    # https://github.com/dask-contrib/dask-awkward/issues/573
    "test_persist"
    "test_ravel_fail"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Native Dask collection for awkward arrays, and the library to use it";
    homepage = "https://github.com/dask-contrib/dask-awkward";
    changelog = "https://github.com/dask-contrib/dask-awkward/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ veprbl ];
    # dask-awkward is incompatible with recent dask versions.
    # See https://github.com/dask-contrib/dask-awkward/pull/582 for context.
    broken = lib.versionAtLeast dask.version "2025.4.0";
  };
})
