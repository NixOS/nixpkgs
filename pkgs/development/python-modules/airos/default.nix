{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  aiohttp,
  mashumaro,
  aiofiles,
  aioresponses,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "airos";
  version = "0.4.3";
  pyproject = true;

  disabled = pythonOlder "3.13";

  src = fetchFromGitHub {
    owner = "CoMPaTech";
    repo = "python-airos";
    tag = "v${version}";
    hash = "sha256-BE5iNmSHugp4gQxCIpMjO0z9V3FQIgD2wYC1qfgOSLc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    mashumaro
  ];

  nativeCheckInputs = [
    aiofiles
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "airos" ];

  meta = {
    description = "Ubiquity airOS module(s) for Python 3";
    homepage = "https://github.com/CoMPaTech/python-airos";
    changelog = "https://github.com/CoMPaTech/python-airos/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
