{
  lib,
  aiohttp,
  aresponses,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  mashumaro,
  poetry-core,
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-freezer,
  pytestCheckHook,
  syrupy,
  typer,
  yarl,
}:

buildPythonPackage rec {
  pname = "easyenergy";
  version = "3.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "klaasnicolaas";
    repo = "python-easyenergy";
    tag = "v${version}";
    hash = "sha256-GzsTAm5D0DVQ7OHfsCwn7Jdv1K1rEhz3KGuERRlTEmI=";
  };

  pythonRelaxDeps = [
    "aiohttp"
    "mashumaro"
  ];

  patches = [ ./typer-0-27-2.patch ];

  build-system = [ poetry-core ];

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  dependencies = [
    aiohttp
    mashumaro
    yarl
  ];

  optional-dependencies = {
    cli = [ typer ];
  };

  nativeCheckInputs = [
    aresponses
    click
    pytest-asyncio
    pytest-cov-stub
    pytest-freezer
    pytestCheckHook
    syrupy
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "easyenergy" ];

  disabledTests = [
    # Tests require network access
    "test_json_request"
    "test_internal_session"
    "test_electricity_model_usage"
    "test_electricity_model_return"
    "test_electricity_none_data"
    "test_no_electricity_data"
    "test_gas_morning_model"
    "test_gas_model"
    "test_gas_none_data"
    "test_no_gas_data"
    "test_electricity_midnight"
    # Syrupy snapshot mismatches in upstream 3.0.1
    "test_electricity_model_quarter_prices"
    "test_electricity_model_invoice_usage"
    "test_electricity_accessors_and_invalid_data_type"
  ];

  meta = {
    description = "Module for getting energy/gas prices from easyEnergy";
    homepage = "https://github.com/klaasnicolaas/python-easyenergy";
    changelog = "https://github.com/klaasnicolaas/python-easyenergy/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    mainProgram = "easyenergy";
    maintainers = with lib.maintainers; [ fab ];
  };
}
