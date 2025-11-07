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
  version = "2.2.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "alexmojaki";
    repo = "executing";
    rev = "v${version}";
    hash = "sha256-2BT4VTZBAJx8Gk4qTTyhSoBMjJvKzmL4PO8IfTpN+2g=";
  };

  patches = [
    (fetchpatch {
      name = "pytest-8.4.1-compat.patch";
      url = "https://github.com/alexmojaki/executing/commit/fae0dd2f4bd0e74b8a928e19407fd4167f4b2295.patch";
      hash = "sha256-ccYBeP4yXf3U4sRyeGUYhLz7QHbXFiMviQ1n+AIVMdo=";
    })
  ];

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

    # https://github.com/alexmojaki/executing/issues/91
    "test_exception_catching"
  ];

  pythonImportsCheck = [ "executing" ];

  meta = with lib; {
    description = "Get information about what a frame is currently doing, particularly the AST node being executed";
    homepage = "https://github.com/alexmojaki/executing";
    license = licenses.mit;
    maintainers = with maintainers; [ renatoGarcia ];
  };
}
