{
  lib,
  aiohttp,
  aioresponses,
  bleak,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  syrupy,
}:

buildPythonPackage rec {
  pname = "pylamarzocco";
  version = "1.4.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "zweckj";
    repo = "pylamarzocco";
    rev = "refs/tags/v${version}";
    hash = "sha256-l9k8cYfYW+4+USDmIAEmXX+6wyDe6tqrjSgQnT8MUKo=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    bleak
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [ "pylamarzocco" ];

  meta = with lib; {
    description = "Library to interface with La Marzocco's cloud";
    homepage = "https://github.com/zweckj/pylamarzocco";
    changelog = "https://github.com/zweckj/pylamarzocco/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
