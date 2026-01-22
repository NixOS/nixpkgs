{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  isPy3k,
  setuptools,
  colorama,
  texttable,
  tqdm,
  certifi,
  housekeeping,
  puremagic,
  pydiffx,
  typing-extensions,
  importlib-metadata,
  importlib-resources,
  packaging,
  pytestCheckHook,
  pytest-env,
  kgb,
  gitSetupHook,
  gitFull,
  subversion,
}:

buildPythonPackage rec {
  pname = "rbtools";
  version = "5.2.1";
  pyproject = true;
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "reviewboard";
    repo = "rbtools";
    tag = "release-${version}";
    hash = "sha256-Ci9lHlP2X95y7ldHBbqb5qWozPj3TJ0AxeVhqzVsdFA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    texttable
    tqdm
    colorama
    certifi
    housekeeping
    puremagic
    pydiffx
    typing-extensions
    importlib-metadata
    importlib-resources
    packaging
  ];

  pythonRelaxDeps = [ "pydiffx" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-env
    kgb
    gitSetupHook
    gitFull
    subversion
  ];

  disabledTestPaths = [
    "rbtools/utils/tests/test_repository.py::RepositoryMatchTests::test_find_matching_server_repository_no_match" # AttributeError: 'APICache' object has no attribute 'db'
    # kgb.errors.ExistingSpyError
    "rbtools/utils/tests/test_repository.py::RepositoryMatchTests::test_find_matching_server_repository_with_mirror_path_match"
    "rbtools/utils/tests/test_repository.py::RepositoryMatchTests::test_find_matching_server_repository_with_multiple_matches"
    "rbtools/utils/tests/test_repository.py::RepositoryMatchTests::test_find_matching_server_repository_with_path_match"
    "rbtools/diffs/tests/test_apple_diff_tool.py::AppleDiffToolTests::test_run_diff_file_with_text_differences" # AssertionError: b'---[38 chars]0000 +0000\n+++ /path2.txt\t2022-09-26 10:20:3[42 chars]ar\n' != b'---[38 chars]0000 -0700\n+++ /path2.txt\t2022-09-26 10:20:3[42 chars]ar\n'
    # rbtools.utils.process.RunProcessError: Unexpected error executing the command: svn co file:///build/source/rbtools/clients/tests/testdata/svn-repo /build/rbtools._bw2ih4g/working/svn-repo
    "rbtools/clients/tests/test_svn.py"
    "rbtools/utils/tests/test_source_tree.py"
    "rbtools/clients/tests/test_scanning.py::ScanningTests::test_scanning_nested_repos_1"
    "rbtools/clients/tests/test_scanning.py::ScanningTests::test_scanning_nested_repos_2"
  ];

  meta = {
    homepage = "https://www.reviewboard.org/docs/rbtools/dev/";
    description = "RBTools is a set of command line tools for working with Review Board and RBCommons";
    mainProgram = "rbt";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
