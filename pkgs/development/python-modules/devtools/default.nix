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
<<<<<<< HEAD
  version = "0.11.0";
=======
  version = "0.10.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "samuelcolvin";
    repo = "python-${pname}";
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-ogogXZnuSFkWktCin+cyefjqIbGFRBVIeOrZJAa3hOE=";
=======
    rev = "v${version}";
    hash = "sha256-x9dL/FE94OixMAmjnmfzZUcYJBqE5P2AAIFsNJF0Fxo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    # Sensitive to timing
    "test_multiple_not_verbose"
    # Sensitive to interpreter output
    "test_simple"
  ];

  disabledTestPaths = [
    # pytester_pretty is not available in Nixpkgs
    "tests/test_insert_assert.py"
=======
    # sensitive to timing
    "test_multiple_not_verbose"
    # sensitive to interpreter output
    "test_simple_vars"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
