{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  aiohttp,
  pydantic,
  tenacity,
  yarl,
  aresponses,
  pytest-cov-stub,
  pytestCheckHook,
  syrupy,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiomelcloudhome";
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "erwindouna";
    repo = "aiomelcloudhome";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OmeKkxx9/+3QYWMlv5fLplSVEOW3fPYurgBoqle8OFI=";
  };

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    pydantic
    tenacity
    yarl
  ];

  nativeCheckInputs = [
    aresponses
    pytest-cov-stub
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [ "aiomelcloudhome" ];

  meta = {
    description = "Asynchronous Python client for the Melcloud Home API";
    homepage = "https://github.com/erwindouna/aiomelcloudhome";
    changelog = "https://github.com/erwindouna/aiomelcloudhome/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
