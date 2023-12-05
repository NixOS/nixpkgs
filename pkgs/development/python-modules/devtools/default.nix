{ lib
, asttokens
, buildPythonPackage
, executing
, hatchling
, fetchFromGitHub
, pygments
, pytest-mock
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "devtools";
  version = "0.12.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "samuelcolvin";
    repo = "python-${pname}";
    rev = "refs/tags/v${version}";
    hash = "sha256-1HFbNswdKa/9cQX0Gf6lLW1V5Kt/N4X6/5kQDdzp1Wo=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    asttokens
    executing
    pygments
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
  ];

  pytestFlagsArray = [
    # pytest.PytestRemovedIn8Warning: Passing None has been deprecated.
    "-W ignore::pytest.PytestRemovedIn8Warning"
  ];

  disabledTests = [
    # Test for Windows32
    "test_print_subprocess"
    # Sensitive to timing
    "test_multiple_not_verbose"
    # Sensitive to interpreter output
    "test_simple"
  ];

  disabledTestPaths = [
    # pytester_pretty is not available in Nixpkgs
    "tests/test_insert_assert.py"
  ];

  pythonImportsCheck = [
    "devtools"
  ];

  meta = with lib; {
    description = "Python's missing debug print command and other development tools";
    homepage = "https://python-devtools.helpmanual.io/";
    changelog = "https://github.com/samuelcolvin/python-devtools/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ jdahm ];
  };
}
