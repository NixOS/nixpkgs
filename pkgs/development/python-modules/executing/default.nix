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
  version = "2.0.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "alexmojaki";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-PBvfkv9GQ5Vj5I5SygtmHXtqqHMJ4XgNV1/I+lSU0/U=";
  };

  patches = lib.optionals (pythonAtLeast "3.12") [
    (fetchpatch { # https://github.com/alexmojaki/executing/pull/83
      url = "https://github.com/alexmojaki/executing/commit/230ef110f004a8cecf03e983561f26a5fecede8f.diff";
      hash = "sha256-McMUIbOWozoDDQSfrJqcxBjuAZ/rrHePfqp5+AVUKI4=";
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
  ];

  pythonImportsCheck = [ "executing" ];

  meta = with lib; {
    description = "Get information about what a frame is currently doing, particularly the AST node being executed";
    homepage = "https://github.com/alexmojaki/executing";
    license = licenses.mit;
    maintainers = with maintainers; [ renatoGarcia ];
  };
}
