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
  version = "0.5.4";
  pyproject = true;

  disabled = pythonOlder "3.13";

  src = fetchFromGitHub {
    owner = "CoMPaTech";
    repo = "python-airos";
    tag = "v${version}";
    hash = "sha256-IiQ/+Ey+CGQfeKRGnNZ54dUSY3t5YMJ1ws7kgc3SQBg=";
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
