{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, poetry-core
, aiohttp
, sensor-state-data
, pytestCheckHook
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "anova-wifi";
  version = "0.11.6";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "Lash-L";
    repo = "anova_wifi";
    rev = "refs/tags/v${version}";
    hash = "sha256-zRMs0GAsLgKt1R0SfRFPchjmk87K2d8vBeHJs66k9xc=";
  };

  postPatch = ''
      substituteInPlace pyproject.toml \
        --replace "--cov=anova_wifi --cov-report=term-missing:skip-covered" ""
    '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
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
    description = "A Python package for reading anova sous vide api data";
    homepage = "https://github.com/Lash-L/anova_wifi";
    changelog = "https://github.com/Lash-L/anova_wifi/releases/tag/v${version}";
    maintainers = with maintainers; [ jamiemagee ];
    license = licenses.mit;
  };
}
