{
  lib,
  aiohttp,
  attrs,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "lyngdorf";
  version = "2.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fishloa";
    repo = "lyngdorf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bCQKKr8woaFM06DYbGz5RmRtZzwQk1MAmYrSIZTzAn8=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    attrs
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "lyngdorf" ];

  meta = {
    description = "Library to control a Lyngdorf A/V processor";
    homepage = "https://github.com/fishloa/lyngdorf";
    changelog = "https://github.com/fishloa/lyngdorf/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
