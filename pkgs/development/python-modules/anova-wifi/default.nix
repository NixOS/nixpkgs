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
  version = "0.10.6";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "Lash-L";
    repo = "anova_wifi";
    rev = "refs/tags/v${version}";
    hash = "sha256-kiHJpmBwres7CECV9VZZDvdErEDvF6Y3vaqz0o+TMXU=";
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
