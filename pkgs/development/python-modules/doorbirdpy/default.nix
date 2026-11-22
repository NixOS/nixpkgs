{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  setuptools,
  aiohttp,
  tenacity,
  aioresponses,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "doorbirdpy";
  version = "3.0.13";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "klikini";
    repo = "doorbirdpy";
    tag = version;
    hash = "sha256-0YTI1t8n7zHXV8EQFCNt39MkD2mg2SkrcIXbRKoq/3k=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    tenacity
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "doorbirdpy" ];

  meta = {
    changelog = "https://gitlab.com/klikini/doorbirdpy/-/tags/${src.tag}";
    description = "Python wrapper for the DoorBird LAN API";
    homepage = "https://gitlab.com/klikini/doorbirdpy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
