{ lib
, buildPythonPackage
, dicttoxml
, fetchFromGitHub
, pythonOlder
, xmltodict
}:

buildPythonPackage rec {
  pname = "pyialarm";
  version = "1.9.0";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "RyuzakiKK";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-mvi8cd9uVFvG1Jc3OeuEwuLjbuMjPRrNRHFUVe3g/NM=";
  };

  propagatedBuildInputs = [
    dicttoxml
    xmltodict
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pyialarm" ];

  meta = with lib; {
    description = "Python library to interface with Antifurto365 iAlarm systems";
    homepage = "https://github.com/RyuzakiKK/pyialarm";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
