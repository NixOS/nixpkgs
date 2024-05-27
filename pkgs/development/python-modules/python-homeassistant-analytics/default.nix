{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  poetry-core,

  # dependencies
  aiohttp,
  yarl,
  mashumaro,
  orjson,

  # tests
  pytestCheckHook,
  aioresponses,
  pytest-asyncio,
  syrupy,
}:

buildPythonPackage rec {
  pname = "python-homeassistant-analytics";
  version = "0.6.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "joostlek";
    repo = "python-homeassistant-analytics";
    rev = "refs/tags/v${version}";
    hash = "sha256-uGi72UCIIvb5XZl7RkiAiR/TS+5VCpyvZfBsmlPzQEs=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "--cov" ""
  '';

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    yarl
    mashumaro
    orjson
  ];

  nativeCheckInputs = [
    pytestCheckHook
    aioresponses
    pytest-asyncio
    syrupy
  ];

  pythonImportsCheck = [ "python_homeassistant_analytics" ];

  meta = with lib; {
    changelog = "https://github.com/joostlek/python-homeassistant-analytics/releases/tag/v${version}";
    description = "Asynchronous Python client for Homeassistant Analytics";
    homepage = "https://github.com/joostlek/python-homeassistant-analytics
";
    license = licenses.mit;
    maintainers = with maintainers; [ jamiemagee ];
  };
}
