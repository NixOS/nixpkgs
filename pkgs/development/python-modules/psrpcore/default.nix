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
  version = "0.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jborean93";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-uX99BsQn1Ckl+2Lt4I0EMZLTKeDrX0mtSc9w5aFpvxQ=";
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
    changelog = "https://github.com/jborean93/psrpcore/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
