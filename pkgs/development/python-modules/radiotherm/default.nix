{ lib
, buildPythonPackage
, fetchFromGitHub
, mock
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "radiotherm";
  version = "2.1.0";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "mhrivnak";
    repo = pname;
    rev = version;
    sha256 = "0p37pc7l2malmjfkdlh4q2cfa6dqpsk1rah2j2xil0pj57ai6bks";
  };

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "radiotherm" ];

  meta = with lib; {
    description = "Python library for Wifi Radiothermostat";
    homepage = "https://github.com/mhrivnak/radiotherm";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
