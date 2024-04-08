{ lib
, buildPythonPackage
, fetchFromGitHub
, mockupdb
, pymongo
, pythonOlder
}:

buildPythonPackage rec {
  pname = "motor";
  version = "3.3.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mongodb";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-ajlZleaaq0LIEW5PdTRQWL312guYA+7+x1xtPNKZQC0=";
  };

  propagatedBuildInputs = [
    pymongo
  ];

  nativeCheckInputs = [
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
