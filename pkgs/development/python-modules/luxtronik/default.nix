{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, poetry-core
, pythonOlder
}:

buildPythonPackage rec {
  pname = "luxtronik";
  version = "0.3.12";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Bouni";
    repo = "python-luxtronik";
    rev = version;
    sha256 = "sha256-qQwMahZ3EzXzI7FyTL71WzDpLqmIgVYxiJ0IGvlw8dY=";
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
