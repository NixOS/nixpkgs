{ lib
, buildPythonPackage
, fetchFromGitHub
, future
, mock
, nose
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "python-ipmi";
  version = "0.5.2";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "kontron";
    repo = pname;
    rev = version;
    sha256 = "sha256-VXWSoVRfgJWf9rOT4SE1mTJdeNmzR3TRc2pc6Pp1M5U=";
  };

  propagatedBuildInputs = [
    future
  ];

  checkInputs = [
    mock
    nose
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyipmi" ];

  meta = with lib; {
    description = "Python IPMI Library";
    homepage = "https://github.com/kontron/python-ipmi";
    license = with licenses; [ lgpl2Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
