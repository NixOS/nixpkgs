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
  pname = "aionatureremo";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tnj";
    repo = "aionatureremo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Z6BfU6f3TD2LY+exUZKYWj/TOcLRKE0wUWXMR/3ddxs=";
  };

  build-system = [ hatchling ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aionatureremo" ];

  meta = {
    description = "Asynchronous Python client for the Nature Remo Cloud API";
    homepage = "https://github.com/tnj/aionatureremo";
    changelog = "https://github.com/tnj/aionatureremo/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
