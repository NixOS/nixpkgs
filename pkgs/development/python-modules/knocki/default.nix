{
  aiohttp,
  aioresponses,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mashumaro,
  orjson,
  poetry-core,
  pytestCheckHook,
  pytest-aiohttp,
  pytest-cov-stub,
  syrupy,
  yarl,
}:

buildPythonPackage rec {
  pname = "knocki";
  version = "0.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "swan-solutions";
    repo = "knocki-homeassistant";
    tag = "v${version}";
    hash = "sha256-85w+fj00VW0miNt+xRMcU6szg/Z7QaeKLGw2BV7X0T4=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    mashumaro
    orjson
    yarl
  ];

  nativeCheckInputs = [
    aioresponses
    pytestCheckHook
    pytest-aiohttp
    pytest-cov-stub
    syrupy
  ];

  pythonImportsCheck = [ "knocki" ];

  meta = {
    description = "Asynchronous Python client for Knocki vibration / door sensors";
    homepage = "https://github.com/swan-solutions/knocki-homeassistant";
    changelog = "https://github.com/swan-solutions/knocki-homeassistant/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mindstorms6 ];
  };
}
