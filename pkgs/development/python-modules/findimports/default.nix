{ lib
, buildPythonPackage
, fetchFromGitHub
, python
, pythonOlder
}:

buildPythonPackage rec {
  pname = "findimports";
  version = "2.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "mgedmin";
    repo = pname;
    rev = version;
    hash = "sha256-p13GVDXDOzOiTnRgtF7UxN1vwZRMa7wVEXJQrFQV7RU=";
  };

  pythonImportsCheck = [
    "findimports"
  ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} testsuite.py
    runHook postCheck
  '';

  meta = with lib; {
    description = "Module for the analysis of Python import statements";
    homepage = "https://github.com/mgedmin/findimports";
    license = with licenses; [ gpl2Only /* or */ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
