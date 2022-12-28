{ lib
, buildPythonPackage
, fetchFromGitHub
, mockupdb
, pymongo
, pythonOlder
}:

buildPythonPackage rec {
  pname = "motor";
  version = "3.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mongodb";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-PD41ZyUFY4fYaO4Fo7kiTWcn1a6LOd81K3PWAAagmr4=";
  };

  propagatedBuildInputs = [
    pymongo
  ];

  checkInputs = [
    mockupdb
  ];

  # network connections
  doCheck = false;

  pythonImportsCheck = [
    "motor"
  ];

  meta = with lib; {
    description = "Non-blocking MongoDB driver for Tornado or asyncio";
    license = licenses.asl20;
    homepage = "https://github.com/mongodb/motor";
    maintainers = with maintainers; [ globin ];
  };
}
