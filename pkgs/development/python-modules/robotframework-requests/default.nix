{ lib
, buildPythonPackage
, fetchFromGitHub
, lxml
, pytestCheckHook
, pythonOlder
, requests
, robotframework
}:

buildPythonPackage rec {
  pname = "robotframework-requests";
  version = "0.9.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "MarketSquare";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-PvhMo1r/4962nntPQb4fQxcMMXIvKjp0FdNyOA43Euc=";
  };

  propagatedBuildInputs = [
    lxml
    requests
    robotframework
  ];

  buildInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "RequestsLibrary"
  ];

  pytestFlagsArray = [
    "utests"
  ];

  meta = with lib; {
    description = "Robot Framework keyword library wrapper around the HTTP client library requests";
    homepage = "https://github.com/bulkan/robotframework-requests";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
