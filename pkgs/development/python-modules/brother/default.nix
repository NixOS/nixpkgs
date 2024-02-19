{ lib
, buildPythonPackage
, fetchFromGitHub
, dacite
, pysnmp-lextudio
, pytest-asyncio
, pytest-error-for-skips
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "brother";
  version = "3.0.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "bieniu";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-rRzcWT9DcNTBUYxyYYC7WORBbrkgj0toCp2e8ADUN5s=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    dacite
    pysnmp-lextudio
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
    changelog = "https://github.com/bieniu/brother/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
