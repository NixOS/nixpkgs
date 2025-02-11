{
  lib,
  aiofiles,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "py-synologydsm-api";
  version = "2.6.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "mib1185";
    repo = "py-synologydsm-api";
    tag = "v${version}";
    hash = "sha256-mkwHw10IzVWtuLGbpY/v7yCJgI6TBIJEo1XSB/NlZKs=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiofiles
    aiohttp
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
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
