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
  syrupy
}:

buildPythonPackage rec {
  pname = "brother";
  version = "4.3.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "bieniu";
    repo = "brother";
    rev = "refs/tags/${version}";
    hash = "sha256-JnIJgR8OiN6y6ib0Y+FXa98Q/4dtvJ8q2r6tgQSRvN4=";
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
