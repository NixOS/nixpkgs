{
  lib,
  aiofiles,
  aiohttp,
  awesomeversion,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
  syrupy,
}:

buildPythonPackage rec {
  pname = "py-synologydsm-api";
  version = "2.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mib1185";
    repo = "py-synologydsm-api";
    tag = "v${version}";
    hash = "sha256-611KEuYzexBsynQy/ZVwcsHfsjObBJTRKdzyuDMnQPA=";
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

  meta = {
    description = "Python API for Synology DSM";
    mainProgram = "synologydsm-api";
    homepage = "https://github.com/mib1185/py-synologydsm-api";
    changelog = "https://github.com/mib1185/py-synologydsm-api/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ uvnikita ];
  };
}
