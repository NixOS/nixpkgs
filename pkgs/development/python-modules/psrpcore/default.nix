{ lib
, buildPythonPackage
, cryptography
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, xmldiff
}:

buildPythonPackage rec {
  pname = "psrpcore";
  version = "0.1.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jborean93";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-f1NGE+wSgi8yqBicZZRfUqzinsqazuIaoAje2y+dK1w=";
  };

  propagatedBuildInputs = [
    cryptography
  ];

  checkInputs = [
    pytestCheckHook
    xmldiff
  ];


  pythonImportsCheck = [
    "psrpcore"
  ];

  meta = with lib; {
    description = "Library for the PowerShell Remoting Protocol (PSRP)";
    homepage = "https://github.com/jborean93/psrpcore";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
