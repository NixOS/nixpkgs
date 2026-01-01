{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
<<<<<<< HEAD
=======
  fetchpatch,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
  version = "2.2.1";
  pyproject = true;

=======
  version = "2.2.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "alexmojaki";
    repo = "executing";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-UlXuXBW9TmJ0xG/0yMdx8EDQDSzVgtsgFJIj/O7pmio=";
  };

=======
    hash = "sha256-2BT4VTZBAJx8Gk4qTTyhSoBMjJvKzmL4PO8IfTpN+2g=";
  };

  patches = [
    (fetchpatch {
      name = "pytest-8.4.1-compat.patch";
      url = "https://github.com/alexmojaki/executing/commit/fae0dd2f4bd0e74b8a928e19407fd4167f4b2295.patch";
      hash = "sha256-ccYBeP4yXf3U4sRyeGUYhLz7QHbXFiMviQ1n+AIVMdo=";
    })
  ];

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
=======

    # https://github.com/alexmojaki/executing/issues/91
    "test_exception_catching"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  pythonImportsCheck = [ "executing" ];

<<<<<<< HEAD
  meta = {
    description = "Get information about what a frame is currently doing, particularly the AST node being executed";
    homepage = "https://github.com/alexmojaki/executing";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ renatoGarcia ];
=======
  meta = with lib; {
    description = "Get information about what a frame is currently doing, particularly the AST node being executed";
    homepage = "https://github.com/alexmojaki/executing";
    license = licenses.mit;
    maintainers = with maintainers; [ renatoGarcia ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
