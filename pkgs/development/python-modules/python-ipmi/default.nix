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
  version = "0.5.1";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "kontron";
    repo = pname;
    rev = version;
    sha256 = "0rcix3q845zsmfj5857kq1r5b8m7m3sad34i23k65m0p58clwdqm";
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
