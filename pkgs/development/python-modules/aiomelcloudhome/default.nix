{
  lib,
  aiohttp,
  aresponses,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pydantic,
  pyprojectVersionPatchHook,
  pytest-cov-stub,
  pytestCheckHook,
  syrupy,
  tenacity,
  yarl,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiomelcloudhome";
  version = "0.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "erwindouna";
    repo = "aiomelcloudhome";
    tag = "v${finalAttrs.version}";
    hash = "sha256-epGyC9Ur6+UnccXjlTg6JZDTA0muDbbQrf9sy4+wJJQ=";
  };

  build-system = [ hatchling ];

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

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
