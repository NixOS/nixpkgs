{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  dacite,
  pysnmp-lextudio,
  pytest-asyncio,
  pytest-error-for-skips,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  syrupy,
}:

buildPythonPackage rec {
  pname = "brother";
  version = "4.2.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "bieniu";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-5fd+UznnOFnqYL8CPX90Y2z6q35oUH638mz4l+Ux6oE=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    dacite
    pysnmp-lextudio
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
