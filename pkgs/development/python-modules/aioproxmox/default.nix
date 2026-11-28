{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  mashumaro,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "aioproxmox";
  version = "0.1.5";
  pyproject = true;

  disabled = pythonOlder "3.14";

  src = fetchFromGitHub {
    owner = "compatech";
    repo = "aioproxmox";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6ZfYZobh2CspIqzaJ5bmkFlONnavukeAs6SNzFzihl4=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools~=80.0" "setuptools"
  '';

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    mashumaro
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aioproxmox" ];

  meta = {
    description = "Asynchronous Python library for Proxmox products";
    homepage = "https://github.com/compatech/aioproxmox";
    changelog = "https://github.com/compatech/aioproxmox/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
