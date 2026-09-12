{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyscorpiontrack";
  version = "0.1.2";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "Herbertmt978";
    repo = "python-scorpiontrack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pv0k8Lw/OW1dxKw7NECCUr6aNqMhBguQhn9GHiQJEc4=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyscorpiontrack" ];

  meta = {
    description = "Async Python client for ScorpionTrack shared-location links";
    homepage = "https://github.com/Herbertmt978/python-scorpiontrack";
    changelog = "https://github.com/Herbertmt978/python-scorpiontrack/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
