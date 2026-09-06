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
  pname = "aioharmanluxury";
  version = "0.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sbesh91";
    repo = "aioharmanluxury";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cQO4oktFErwYc3sjRuBU+vavaeHjvyCxMZequc2A1jw=";
  };

  build-system = [ hatchling ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aioharmanluxury" ];

  meta = {
    description = "Async client for Harman Luxury Audio network streamers";
    homepage = "https://github.com/sbesh91/aioharmanluxury";
    changelog = "https://github.com/sbesh91/aioharmanluxury/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
