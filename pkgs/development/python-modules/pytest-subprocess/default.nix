{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pytest
, pytestCheckHook
, docutils
, pygments
}:

buildPythonPackage rec {
  pname = "pytest-subprocess";
  version = "1.1.0";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "aklajnert";
    repo = "pytest-subprocess";
    rev = version;
    sha256 = "sha256-r6WNDdvZAHMG1kPtLJlCwvhbVG1gC1NEvRfta+Chxnk=";
  };

  buildInputs = [
    pytest
  ];

  checkInputs = [
    pytestCheckHook
    docutils
    pygments
  ];

  disabledTests = [
    "test_multiple_wait" # https://github.com/aklajnert/pytest-subprocess/issues/36
  ];

  meta = with lib; {
    description = "A plugin to fake subprocess for pytest";
    homepage = "https://github.com/aklajnert/pytest-subprocess";
    changelog = "https://github.com/aklajnert/pytest-subprocess/blob/${version}/HISTORY.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
