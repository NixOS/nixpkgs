{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pydelijn";
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bollewolle";
    repo = "pydelijn";
    tag = "v${finalAttrs.version}";
    hash = "sha256-13BMHMdjnTrGGdVrrKT3zlDgiC1V7qXiD2XCX4PT+WY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pydelijn" ];

  meta = {
    changelog = "https://github.com/bollewolle/pydelijn/releases/tag/${finalAttrs.src.tag}";
    description = "Python package to retrieve realtime data of passages at stops of De Lijn";
    homepage = "https://github.com/bollewolle/pydelijn";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
