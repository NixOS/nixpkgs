{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, requests
, requests-mock
}:

buildPythonPackage rec {
  pname = "losant-rest";
  version = "1.16.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Losant";
    repo = "losant-rest-python";
    rev = "v${version}";
    sha256 = "sha256-s9WPr5sFSyPIDRgRYcD55iRLhaVIvkiDGg/m//6acFY=";
  };

  propagatedBuildInputs = [
    requests
  ];

  checkInputs = [
    pytestCheckHook
    requests-mock
  ];

  pytestFlagsArray = [
    "tests/losantrest_tests.py"
  ];

  pythonImportsCheck = [
    "losantrest"
  ];

  meta = with lib; {
    description = "Python module for consuming the Losant IoT Platform API";
    homepage = "https://github.com/Losant/losant-rest-python";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
