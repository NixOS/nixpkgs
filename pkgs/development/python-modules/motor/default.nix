{ lib
, buildPythonPackage
, fetchFromGitHub
, mockupdb
, pymongo
, pythonOlder
}:

buildPythonPackage rec {
  pname = "motor";
  version = "2.5.1";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "mongodb";
    repo = pname;
    rev = version;
    sha256 = "sha256-r+HyIEC+Jafn7eMqkAldsZ5hbem+n+P76RJGAymmBks=";
  };

  propagatedBuildInputs = [ pymongo ];

  checkInputs = [ mockupdb ];

  # network connections
  doCheck = false;

  pythonImportsCheck = [ "motor" ];

  meta = with lib; {
    description = "Non-blocking MongoDB driver for Tornado or asyncio";
    license = licenses.asl20;
    homepage = "https://github.com/mongodb/motor";
    maintainers = with maintainers; [ globin ];
  };
}
