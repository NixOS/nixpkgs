{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
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
  version = "2.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "alexmojaki";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-epgKMPOvPdkpRp0n5A22gZ5DeXLyI60bqzLTx5JFlLk=";
  };

  patches = [
    (fetchpatch {
      name = "python-3.12.6.patch";
      url = "https://github.com/alexmojaki/executing/commit/3f11fdcd7a017fbdca8a3a9de23dab18d3ba2100.patch";
      hash = "sha256-ZnTO9lT+bj4nekPx4D0DxjhJOCkZn6lDm5xdLrziB+4=";
    })
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
