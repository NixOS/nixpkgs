{
  aiohttp,
  aioresponses,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mashumaro,
  orjson,
  poetry-core,
  pythonOlder,
  pytestCheckHook,
  pytest-aiohttp,
  syrupy,
  yarl,
}:

buildPythonPackage rec {
  pname = "knocki";
  version = "0.4.2";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "swan-solutions";
    repo = "knocki-homeassistant";
    tag = "v${version}";
    hash = "sha256-85w+fj00VW0miNt+xRMcU6szg/Z7QaeKLGw2BV7X0T4=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "addopts = \"--cov\"" ""
  '';

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
    syrupy
  ];

  pythonImportsCheck = [ "knocki" ];

  meta = with lib; {
    description = "Asynchronous Python client for Knocki vibration / door sensors";
    homepage = "https://github.com/swan-solutions/knocki-homeassistant";
    changelog = "https://github.com/swan-solutions/knocki-homeassistant/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ mindstorms6 ];
  };
}
