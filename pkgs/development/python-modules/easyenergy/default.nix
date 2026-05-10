{
  lib,
  aiohttp,
  aresponses,
  buildPythonPackage,
  fetchFromGitHub,
  mashumaro,
  poetry-core,
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
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "klaasnicolaas";
    repo = "python-easyenergy";
    tag = "v${version}";
    hash = "sha256-aCRXL//hGJyG1eIonz/HJqFyG9eGKOoFhd6yD5zAR3s=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace '"0.0.0"' '"${version}"'
  '';

  build-system = [ poetry-core ];

  pythonRelaxDeps = [
    "aiohttp"
    "mashumaro"
  ];

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
