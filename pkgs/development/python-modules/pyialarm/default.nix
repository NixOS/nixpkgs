{ lib
, buildPythonPackage
, dicttoxml2
, fetchFromGitHub
, pythonOlder
, xmltodict
}:

buildPythonPackage rec {
  pname = "pyialarm";
  version = "2.2.0";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "RyuzakiKK";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-rOdeYewjoFVbHdNPHN6ZC2g6X5yr84/JFE6tGSDIoRU=";
  };

  propagatedBuildInputs = [
    dicttoxml2
    xmltodict
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "pyialarm"
  ];

  meta = with lib; {
    description = "Python library to interface with Antifurto365 iAlarm systems";
    homepage = "https://github.com/RyuzakiKK/pyialarm";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
