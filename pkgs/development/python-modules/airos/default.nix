{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools_80,
  aiohttp,
  mashumaro,
  aiofiles,
  aioresponses,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "airos";
  version = "0.6.13";
  pyproject = true;

  disabled = pythonOlder "3.13";

  src = fetchFromGitHub {
    owner = "CoMPaTech";
    repo = "python-airos";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GiAtW6wQvOuDT0+ZMeMcpnZDey7bkFzbh1Eo0b5Pth4=";
  };

  build-system = [ setuptools_80 ];

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
    changelog = "https://github.com/CoMPaTech/python-airos/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
