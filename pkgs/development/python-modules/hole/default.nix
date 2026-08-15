{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "hole";
  version = "0.9.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-ecosystem";
    repo = "python-hole";
    tag = finalAttrs.version;
    hash = "sha256-j9fwetfxc0HG+Ly+MpRYL3jDHAwtt+Ls3tUcizHuUrg=";
  };

  build-system = [ hatchling ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "hole" ];

  meta = {
    description = "Python API for interacting with a Pihole instance";
    homepage = "https://github.com/home-assistant-ecosystem/python-hole";
    changelog = "https://github.com/home-assistant-ecosystem/python-hole/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
