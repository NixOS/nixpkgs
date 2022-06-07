{ lib
, buildPythonPackage
, fetchFromGitHub
, flask
, mock
, prettytable
, pyserial
, pytestCheckHook
, pythonOlder
, requests
, stevedore
}:

buildPythonPackage rec {
  pname = "pynx584";
  version = "0.8";
  disabled = pythonOlder "3.6";


  src = fetchFromGitHub {
    owner = "kk7ds";
    repo = pname;
    rev = version;
    sha256 = "sha256-aTwAQnz3my58MgXNe61lStLth6PZXLVLLDI2HUJiNm8=";
  };

  propagatedBuildInputs = [
    flask
    prettytable
    pyserial
    requests
    stevedore
  ];

  checkInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "nx584" ];

  meta = with lib; {
    description = "Python package for communicating to NX584/NX8E interfaces";
    homepage = "https://github.com/kk7ds/pynx584";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
