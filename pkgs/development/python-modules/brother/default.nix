{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  dacite,
  pysnmp,
  pytest-asyncio,
  pytest-error-for-skips,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  syrupy,
}:

buildPythonPackage rec {
  pname = "brother";
  version = "4.3.1";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "bieniu";
    repo = "brother";
    rev = "refs/tags/${version}";
    hash = "sha256-fWa5FNBGV8tnJ3CozMicXLGsDvnTjNzU8PdV266MeeQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    dacite
    pysnmp
  ];

  nativeCheckInputs = [
    freezegun
    pytest-asyncio
    pytest-error-for-skips
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [ "brother" ];

  meta = with lib; {
    description = "Python wrapper for getting data from Brother laser and inkjet printers via SNMP";
    homepage = "https://github.com/bieniu/brother";
    changelog = "https://github.com/bieniu/brother/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
