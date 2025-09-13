{
  lib,
  stdenv,
  bottle,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonAtLeast,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pympler";
  version = "1.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HqqGfLiZLCGEMPFwj9rM2lPfBkFE0cVlax5vHuYABCQ=";
  };

  build-system = [ setuptools ];

  # There is a version of bottle bundled with Pympler, but it is broken on
  # Python 3.11. Fortunately, Pympler will preferentially import an external
  # bottle if it is available, so we make it an explicit dependency.
  dependencies = [ bottle ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # 'AssertionError: 'function (test.muppy.test_summary.func)' != 'function (muppy.test_summary.func)'
    # https://github.com/pympler/pympler/issues/134
    "test_repr_function"
    # Stuck
    "test_locals"
    "test_globals"
    "test_traceback"
    "test_otracker_diff"
    "test_stracker_store_summary"
  ]
  ++ lib.optionals (pythonAtLeast "3.11") [
    # https://github.com/pympler/pympler/issues/148
    "test_findgarbage"
    "test_get_tree"
    "test_prune"
  ]
  ++ lib.optionals (pythonAtLeast "3.13") [
    # https://github.com/pympler/pympler/issues/163
    "test_edges_new"
    "test_edges_old"
    "test_split"
  ];

  doCheck = stdenv.hostPlatform.isLinux;

  meta = with lib; {
    description = "Tool to measure, monitor and analyze memory behavior";
    homepage = "https://github.com/pympler/pympler";
    license = licenses.asl20;
  };
}
