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
  version = "1.0.1";

  disabled = pythonOlder "3.4";

  src = fetchFromGitHub {
    owner = "aklajnert";
    repo = "pytest-subprocess";
    rev = version;
    sha256 = "16ghwyv1vy45dd9cysjvcvvpm45958x071id2qrvgaziy2j6yx3j";
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
