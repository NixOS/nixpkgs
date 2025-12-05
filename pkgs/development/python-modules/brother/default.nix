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
  version = "6.0.0";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "bieniu";
    repo = "brother";
    tag = version;
    hash = "sha256-kvR4891kaZFHKZhtgrrgtGJZUIwoYE5CsGUEQM7eKvs=";
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
    changelog = "https://github.com/bieniu/brother/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
