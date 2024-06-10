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
}:

buildPythonPackage rec {
  pname = "anova-wifi";
  version = "0.12.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "Lash-L";
    repo = "anova_wifi";
    rev = "refs/tags/v${version}";
    hash = "sha256-0RRnQBLglPnPin9/gqWDKIsfi5V7ydrdDKwm93WEnvk=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "--cov=anova_wifi --cov-report=term-missing:skip-covered" ""
  '';

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    sensor-state-data
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  disabledTests = [
    # Makes network calls
    "test_async_data_1"
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
