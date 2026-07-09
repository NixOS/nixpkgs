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
  version = "0.1.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "erwindouna";
    repo = "aiomelcloudhome";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aYaV7+Lj7LShO0HqoUjSFAMTOHY5piMdSACOVizGgco=";
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
