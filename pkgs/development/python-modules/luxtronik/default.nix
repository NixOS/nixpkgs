{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, poetry-core
, pythonOlder
}:

buildPythonPackage rec {
  pname = "luxtronik";
  version = "0.3.13";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Bouni";
    repo = "python-luxtronik";
    rev = version;
    sha256 = "sha256-ULpi3oNJJe8H9z1C1nCNsR5eMmXQnXtbonrV9Ec2NyY=";
  };

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "luxtronik"
  ];

  meta = with lib; {
    description = "Python library to interact with Luxtronik heatpump controllers";
    homepage = "https://github.com/Bouni/python-luxtronik";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
