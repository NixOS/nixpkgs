{ lib
, appdirs
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "nmapthon2";
  version = "0.1.5";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "cblopez";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-4Na75TdKDywUomJF4tDWUWwCCtcOSxBUMOF7+FDhbpY=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "tests/scanner_tests.py"
  ];

  pythonImportsCheck = [
    "nmapthon2"
  ];

  meta = with lib; {
    description = "Python library to automate nmap";
    homepage = "https://github.com/cblopez/nmapthon2";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
