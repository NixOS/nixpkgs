{
  lib,
  acme,
  aiohttp,
  async-timeout,
  atomicwrites-homeassistant,
  attrs,
  buildPythonPackage,
  ciso8601,
  cryptography,
  fetchFromGitHub,
  freezegun,
  josepy,
  litellm,
  pycognito,
  pyjwt,
  pytest-aiohttp,
  pytest-socket,
  pytest-timeout,
  pytestCheckHook,
  pythonOlder,
  sentence-stream,
  setuptools,
  snitun,
  syrupy,
  voluptuous,
  webrtc-models,
  xmltodict,
  yarl,
}:

buildPythonPackage rec {
  pname = "hass-nabucasa";
  version = "1.6.1";
  pyproject = true;

  disabled = pythonOlder "3.13";

  src = fetchFromGitHub {
    owner = "nabucasa";
    repo = "hass-nabucasa";
    tag = version;
    hash = "sha256-LBJPzMosSgfdONu2preIBKmlKhY4P+jFTmR8u2BKCZI=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "0.0.0" "${version}"
  '';

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "acme"
    "snitun"
  ];

  dependencies = [
    acme
    aiohttp
    async-timeout
    atomicwrites-homeassistant
    attrs
    ciso8601
    cryptography
    josepy
    litellm
    pycognito
    pyjwt
    sentence-stream
    snitun
    voluptuous
    webrtc-models
    yarl
  ];

  nativeCheckInputs = [
    freezegun
    pytest-aiohttp
    pytest-socket
    pytest-timeout
    pytestCheckHook
    syrupy
    xmltodict
  ];

  pythonImportsCheck = [ "hass_nabucasa" ];

  meta = with lib; {
    description = "Python module for the Home Assistant cloud integration";
    homepage = "https://github.com/NabuCasa/hass-nabucasa";
    changelog = "https://github.com/NabuCasa/hass-nabucasa/releases/tag/${src.tag}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ Scriptkiddi ];
  };
}
