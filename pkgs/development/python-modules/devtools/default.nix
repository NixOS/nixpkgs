{
  lib,
  asttokens,
  buildPythonPackage,
  executing,
  hatchling,
  fetchFromGitHub,
  pygments,
  pytest-mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "devtools";
  version = "0.12.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "samuelcolvin";
    repo = "python-${pname}";
    tag = "v${version}";
    hash = "sha256-1HFbNswdKa/9cQX0Gf6lLW1V5Kt/N4X6/5kQDdzp1Wo=";
  };

  patches = [
    # https://github.com/samuelcolvin/python-devtools/pull/166
    ./fix-test-ast-expr.patch
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'asttokens>=2.0.0,<3.0.0' 'asttokens>=2.0.0' \
  '';

  build-system = [ hatchling ];

  dependencies = [
    asttokens
    executing
    pygments
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
  ];

  disabledTests = [
    # Test for Windows32
    "test_print_subprocess"
    # Sensitive to timing
    "test_multiple_not_verbose"
    # Sensitive to interpreter output
    "test_simple"
    "test_expr_render"
  ];

  disabledTestPaths = [
    # pytester_pretty is not available in Nixpkgs
    "tests/test_insert_assert.py"
  ];

  pythonImportsCheck = [ "devtools" ];

  meta = with lib; {
    description = "Python's missing debug print command and other development tools";
    homepage = "https://python-devtools.helpmanual.io/";
    changelog = "https://github.com/samuelcolvin/python-devtools/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ jdahm ];
  };
}
