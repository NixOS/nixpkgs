{ lib
, aiohttp
, aresponses
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytest-asyncio
, pytest-freezer
, pytestCheckHook
, pythonOlder
, yarl
}:

buildPythonPackage rec {
  pname = "easyenergy";
  version = "0.3.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "klaasnicolaas";
    repo = "python-easyenergy";
    rev = "refs/tags/v${version}";
    hash = "sha256-J+iWmbuaEErrMxF62rf/L8Rkqo7/7RDXv0CmIuywbjI=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace '"0.0.0"' '"${version}"' \
      --replace 'addopts = "--cov"' ""
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    yarl
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytest-freezer
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "easyenergy"
  ];

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
    changelog = "https://github.com/klaasnicolaas/python-easyenergy/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
