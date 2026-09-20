{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  pydantic,
  async-upnp-client,
  m3u8,
  mutagen,
  pytest-asyncio,
  pytestCheckHook,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "pywiim";
  version = "2.3.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mjcumming";
    repo = "pywiim";
    tag = "v${version}";
    hash = "sha256-ORAC/94C8Q/ASr8qZmRQg2tlc46G4nLJg9+EHgJwGQ0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    pydantic
    async-upnp-client
    m3u8
    mutagen
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    pyyaml
  ];

  enabledTestPaths = [ "tests/unit" ];

  pythonImportsCheck = [ "pywiim" ];

  meta = {
    description = "Python library for WiiM/LinkPlay device communication";
    homepage = "https://github.com/mjcumming/pywiim";
    changelog = "https://github.com/mjcumming/pywiim/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ linuxissuper ];
  };
}
