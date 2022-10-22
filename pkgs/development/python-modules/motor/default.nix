{ lib
, buildPythonPackage
, fetchFromGitHub
, mockupdb
, pymongo
, pythonOlder
}:

buildPythonPackage rec {
  pname = "motor";
  version = "3.1.0";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "mongodb";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-Wc0C4sO33v/frBtZVV2u9ESunHKyJI+eQ59l72h2eFk=";
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
