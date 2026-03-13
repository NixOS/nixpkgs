{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  music-assistant,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiovban";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wmbest2";
    repo = "aiovban";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0mhpmpsV0zSOWbhrPF9bfR9xAtJe6X57guWDZWMH6f0=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "aiovban"
  ];

  meta = {
    changelog = "https://github.com/wmbest2/aiovban/releases/tag/${finalAttrs.src.tag}";
    description = "Asyncio VBAN Protocol Wrapper";
    homepage = "https://github.com/wmbest2/aiovban";
    license = lib.licenses.mit;
    inherit (music-assistant.meta) maintainers;
  };
})
