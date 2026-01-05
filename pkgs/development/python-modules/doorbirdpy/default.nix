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
  version = "3.0.10";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "klikini";
    repo = "doorbirdpy";
    tag = version;
    hash = "sha256-7mA4yyvNPKOGb6Ap7kjCLhR7G1E1CQqgWCtAhciCnR4=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "tenacity"
  ];

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
