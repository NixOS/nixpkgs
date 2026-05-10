{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,

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
  version = "2.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "alexmojaki";
    repo = "executing";
    rev = "v${version}";
    hash = "sha256-UlXuXBW9TmJ0xG/0yMdx8EDQDSzVgtsgFJIj/O7pmio=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
    asttokens
    littleutils
    pytestCheckHook
  ]
  ++ lib.optionals (pythonAtLeast "3.11") [ rich ];

  disabledTests = [
    # requires ipython, which causes a circular dependency
    "test_two_statement_lookups"

    # Asserts against time passed using time.time() to estimate
    # if the test runs fast enough. That makes the test flaky when
    # running on slow systems or cross- / emulated building
    "test_many_source_for_filename_calls"
  ];

  pythonImportsCheck = [ "executing" ];

  meta = {
    description = "Get information about what a frame is currently doing, particularly the AST node being executed";
    homepage = "https://github.com/alexmojaki/executing";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ renatoGarcia ];
  };
}
