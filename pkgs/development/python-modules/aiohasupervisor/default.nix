{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  mashumaro,
  orjson,
  pytest-aiohttp,
  pytest-cov-stub,
  pytest-timeout,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  yarl,
}:

buildPythonPackage rec {
  pname = "aiohasupervisor";
  version = "0.3.3";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "python-supervisor-client";
    tag = version;
    hash = "sha256-v6w+g1M3VR/an3a5MfWf8fDCHNzRC4+05L7GW45PzWU=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${version}"' \
      --replace-fail "setuptools>=68.0,<80.10" "setuptools"
  '';

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    mashumaro
    orjson
    yarl
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-aiohttp
    pytest-cov-stub
    pytest-timeout
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiohasupervisor" ];

  meta = {
    description = "Client for Home Assistant Supervisor";
    homepage = "https://github.com/home-assistant-libs/python-supervisor-client";
    changelog = "https://github.com/home-assistant-libs/python-supervisor-client/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
