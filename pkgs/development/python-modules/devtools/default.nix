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
  version = "0.10.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "samuelcolvin";
    repo = "python-${pname}";
    rev = "v${version}";
    sha256 = "sha256-x9dL/FE94OixMAmjnmfzZUcYJBqE5P2AAIFsNJF0Fxo=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    asttokens
    executing
    pygments
  ];

  checkInputs = [
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
    # sensitive to timing
    "test_multiple_not_verbose"
    # sensitive to interpreter output
    "test_simple_vars"
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
