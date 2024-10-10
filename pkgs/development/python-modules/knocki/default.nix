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
  version = "0.3.5";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "swan-solutions";
    repo = "knocki-homeassistant";
    rev = "refs/tags/v${version}";
    hash = "sha256-Fb3skFttY5gtm80k1LCUQ4Z7/TQGClCNcWt1k6bLQoI=";
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
    license = licenses.mit;
    maintainers = with maintainers; [ mindstorms6 ];
  };
}
