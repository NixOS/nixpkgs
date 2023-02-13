{ lib
, buildPythonPackage
, fetchFromGitHub
, dacite
, pysnmplib
, pytest-asyncio
, pytest-error-for-skips
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "brother";
  version = "2.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bieniu";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-jMvbZ4/NOA3dnJUdDWk2KTRz1gBOC+oDE0ChGNdFl1o=";
  };

  propagatedBuildInputs = [
    dacite
    pysnmplib
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-error-for-skips
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "brother"
  ];

  meta = with lib; {
    description = "Python wrapper for getting data from Brother laser and inkjet printers via SNMP";
    homepage = "https://github.com/bieniu/brother";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
