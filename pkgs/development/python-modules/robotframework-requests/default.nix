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
<<<<<<< HEAD
  version = "0.9.5";
=======
  version = "0.9.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "MarketSquare";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-PvhMo1r/4962nntPQb4fQxcMMXIvKjp0FdNyOA43Euc=";
=======
    hash = "sha256-XjcR29dH9K9XEnJZlQ4UUDI1MG92dRO1puiB6fcN58k=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
