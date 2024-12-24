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
  version = "1.4.1";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "zweckj";
    repo = "pylamarzocco";
    rev = "refs/tags/v${version}";
    hash = "sha256-fbXqAPyx6pGEKM+invdq88dDyiLJpyjL3idalnk0RUQ=";
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
