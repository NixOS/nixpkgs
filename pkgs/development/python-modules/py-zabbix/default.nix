{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "py-zabbix";
  version = "1.1.7";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "adubkov";
    repo = "py-zabbix";
    rev = version;
    sha256 = "aPQc188pszfDQvNtsGYlRLHS5CG5VyqptSoe4/GJVvE=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pyzabbix"
  ];

  meta = with lib; {
    description = "Python module to interact with Zabbix";
    homepage = "https://github.com/adubkov/py-zabbix";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ fab ];
  };
}
