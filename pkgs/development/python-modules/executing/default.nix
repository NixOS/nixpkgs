{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,
  pythonOlder,

  # build-system
  setuptools,
  setuptools-scm,

  # tests
  asttokens,
  littleutils,
  rich,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "executing";
  version = "2.0.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "alexmojaki";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-PBvfkv9GQ5Vj5I5SygtmHXtqqHMJ4XgNV1/I+lSU0/U=";
  };

  patches = [
    # TODO: replace after the PR is merged or tagged
    ./get_iter.patch
  ];

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
    asttokens
    littleutils
    pytestCheckHook
  ] ++ lib.optionals (pythonAtLeast "3.11") [ rich ];

  disabledTests = [
    # requires ipython, which causes a circular dependency
    "test_two_statement_lookups"

    # Asserts against time passed using time.time() to estimate
    # if the test runs fast enough. That makes the test flaky when
    # running on slow systems or cross- / emulated building
    "test_many_source_for_filename_calls"
  ];

  pythonImportsCheck = [ "executing" ];

  meta = with lib; {
    description = "Get information about what a frame is currently doing, particularly the AST node being executed";
    homepage = "https://github.com/alexmojaki/executing";
    license = licenses.mit;
    maintainers = with maintainers; [ renatoGarcia ];
  };
}
