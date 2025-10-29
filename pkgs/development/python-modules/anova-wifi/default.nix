{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  poetry-core,
  aiohttp,
  sensor-state-data,
  pytestCheckHook,
  pytest-asyncio,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "anova-wifi";
  version = "0.17.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "Lash-L";
    repo = "anova_wifi";
    tag = "v${version}";
    hash = "sha256-TRiv5ljdVqc4qeX+fSH+aTDf5UyNII8/twlNx3KC6oI=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    sensor-state-data
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-cov-stub
  ];

  disabledTests = [
    # Makes network calls
    "test_async_data_1"
    # async def functions are not natively supported.
    "test_can_create"
  ];

  pythonImportsCheck = [ "anova_wifi" ];

  meta = with lib; {
    description = "Python package for reading anova sous vide api data";
    homepage = "https://github.com/Lash-L/anova_wifi";
    changelog = "https://github.com/Lash-L/anova_wifi/releases/tag/v${version}";
    maintainers = with maintainers; [ jamiemagee ];
    license = licenses.mit;
  };
}
