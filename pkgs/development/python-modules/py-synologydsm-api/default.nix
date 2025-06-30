{
  lib,
  aiofiles,
  aiohttp,
  awesomeversion,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  syrupy,
}:

buildPythonPackage rec {
  pname = "py-synologydsm-api";
  version = "2.7.3";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "mib1185";
    repo = "py-synologydsm-api";
    tag = "v${version}";
    hash = "sha256-LaeqAY+8WfoMwrZhwZUEcuafGvv+7reuxEh8zQ7j5S4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiofiles
    aiohttp
    awesomeversion
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [ "synology_dsm" ];

  meta = with lib; {
    description = "Python API for Synology DSM";
    mainProgram = "synologydsm-api";
    homepage = "https://github.com/mib1185/py-synologydsm-api";
    changelog = "https://github.com/mib1185/py-synologydsm-api/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ uvnikita ];
  };
}
