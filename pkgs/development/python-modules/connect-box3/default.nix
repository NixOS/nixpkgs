{
  lib,
  buildPythonPackage,
  cyclopts,
  fetchFromGitHub,
  hatchling,
  httpx,
  mashumaro,
  pytest-asyncio,
  pytest-httpx,
  pytestCheckHook,
  rich,
}:

buildPythonPackage (finalAttrs: {
  pname = "connect-box3";
  version = "0.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-ecosystem";
    repo = "python-connect-box3";
    tag = finalAttrs.version;
    hash = "sha256-DwR/B0qB8XS3o/MAjC7Cvh83nBm95gkTbxW8gF3ws0g=";
  };

  build-system = [ hatchling ];

  dependencies = [
    cyclopts
    httpx
    mashumaro
    rich
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-httpx
  ];

  pythonImportsCheck = [ "connect_box3" ];

  meta = {
    description = "Interact with a Connect Box 3 modem/router";
    homepage = "https://github.com/home-assistant-ecosystem/python-connect-box3";
    changelog = "https://github.com/home-assistant-ecosystem/python-connect-box3/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "connect-box";
  };
})
