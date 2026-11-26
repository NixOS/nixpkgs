{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  uv-build,
  aiohttp,
  aioresponses,
  pytest-asyncio,
  pytestCheckHook,
  pyyaml,
  syrupy,
}:

buildPythonPackage (finalAttrs: {
  pname = "aioengiebelgium";
  version = "0.8.2";
  pyproject = true;

  disabled = pythonOlder "3.14";

  src = fetchFromGitHub {
    owner = "DaanVervacke";
    repo = "aioengiebelgium";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TfecqqRA+2nTMj+8wqSOMznHdFe0ZdVwTM3j557uHB8=";
  };

  build-system = [ uv-build ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
    pyyaml
    syrupy
  ];

  pythonImportsCheck = [ "aioengiebelgium" ];

  meta = {
    description = "Unofficial asynchronous Python library to interact with the ENGIE Belgium API";
    homepage = "https://github.com/DaanVervacke/aioengiebelgium";
    changelog = "https://github.com/DaanVervacke/aioengiebelgium/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
