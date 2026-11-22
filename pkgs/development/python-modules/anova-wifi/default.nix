{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  aiohttp,
  sensor-state-data,
  pytestCheckHook,
  pytest-asyncio,
  pytest-cov-stub,
}:

buildPythonPackage (finalAttrs: {
  pname = "anova-wifi";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Lash-L";
    repo = "anova_wifi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-StQ3kQTeYf+MfoTmbKR+G9wZoGyzjKkzuiR5xpDnoto=";
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
  ];

  pythonImportsCheck = [ "anova_wifi" ];

  meta = {
    description = "Python package for reading anova sous vide api data";
    homepage = "https://github.com/Lash-L/anova_wifi";
    changelog = "https://github.com/Lash-L/anova_wifi/releases/tag/${finalAttrs.src.tag}";
    maintainers = with lib.maintainers; [ jamiemagee ];
    license = lib.licenses.mit;
  };
})
