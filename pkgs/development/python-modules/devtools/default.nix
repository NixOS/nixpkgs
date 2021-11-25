{ lib
, asttokens
, buildPythonPackage
, executing
, fetchFromGitHub
, pygments
, pytest-mock
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "devtools";
  version = "0.8.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "samuelcolvin";
    repo = "python-${pname}";
    rev = "v${version}";
    sha256 = "0yavcbxzxi1nfa1k326gsl03y8sadi5z5acamwd8b1bsiv15p757";
  };

  propagatedBuildInputs = [
    asttokens
    executing
    pygments
  ];

  checkInputs = [
    pytestCheckHook
    pytest-mock
  ];

  disabledTests = [
    # Test for Windows32
    "test_print_subprocess"
  ];

  pythonImportsCheck = [
    "devtools"
  ];

  meta = with lib; {
    description = "Python's missing debug print command and other development tools";
    homepage = "https://python-devtools.helpmanual.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ jdahm ];
  };
}
