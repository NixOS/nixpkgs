{
  lib,
  aiohttp,
  aresponses,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-freezer,
  pytestCheckHook,
  pythonOlder,
  syrupy,
  yarl,
}:

buildPythonPackage rec {
  pname = "easyenergy";
  version = "2.2.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "klaasnicolaas";
    repo = "python-easyenergy";
    tag = "v${version}";
    hash = "sha256-AFEygSSHr7YJK4Yx4dvBVGR3wBswAeUNrC/7NndzfBg=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace '"0.0.0"' '"${version}"'
  '';

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    aiohttp
    yarl
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytest-cov-stub
    pytest-freezer
    pytestCheckHook
    syrupy
  ];

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

  meta = with lib; {
    description = "Module for getting energy/gas prices from easyEnergy";
    homepage = "https://github.com/klaasnicolaas/python-easyenergy";
    changelog = "https://github.com/klaasnicolaas/python-easyenergy/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
