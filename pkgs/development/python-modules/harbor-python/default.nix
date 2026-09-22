{
  lib,
  aiomqtt,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pydantic,
  pytest-asyncio,
  pytest-timeout,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "harbor-python";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Harbor-Systems";
    repo = "harbor-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sdC7b355JlkliTXiPbSPKykRQ8QJ83CVEMoT53+lVj8=";
  };

  build-system = [ hatchling ];

  dependencies = [
    aiomqtt
    pydantic
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-timeout
    pytestCheckHook
  ];

  pythonImportsCheck = [ "harbor" ];

  meta = {
    description = "Async local client for Harbor Sleep Cameras";
    homepage = "https://github.com/Harbor-Systems/harbor-python";
    changelog = "https://github.com/Harbor-Systems/harbor-python/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
