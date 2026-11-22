{
  lib,
  aiohttp,
  aresponses,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  pytz,
  yarl,
}:

buildPythonPackage (finalAttrs: {
  pname = "eiswarnung";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "klaasnicolaas";
    repo = "python-eiswarnung";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/61qrRfD7/gaEcvFot34HYXOVLWwTDi/fvcgHDTv9u0=";
  };

  __darwinAllowLocalNetworking = true;

  pythonRelaxDeps = [ "pytz" ];

  build-system = [ poetry-core ];

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  dependencies = [
    aiohttp
    pytz
    yarl
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "eiswarnung" ];

  meta = {
    description = "Module for getting Eiswarning API forecasts";
    homepage = "https://github.com/klaasnicolaas/python-eiswarnung";
    changelog = "https://github.com/klaasnicolaas/python-eiswarnung/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
