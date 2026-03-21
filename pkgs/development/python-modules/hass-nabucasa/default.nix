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
  grpcio,
  icmplib,
  josepy,
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

buildPythonPackage (finalAttrs: {
  pname = "hass-nabucasa";
  version = "1.15.0";
  pyproject = true;

  disabled = pythonOlder "3.13";

  src = fetchFromGitHub {
    owner = "nabucasa";
    repo = "hass-nabucasa";
    tag = finalAttrs.version;
    hash = "sha256-WwpCAIfl/2fp01v9Rq4tQW70aoVlvhEJl31XQTAENmA=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "0.0.0" "${finalAttrs.version}"
  '';

  build-system = [ setuptools ];

  dependencies = [
    acme
    aiohttp
    async-timeout
    atomicwrites-homeassistant
    attrs
    ciso8601
    cryptography
    grpcio
    icmplib
    josepy
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

  meta = {
    description = "Python module for the Home Assistant cloud integration";
    homepage = "https://github.com/NabuCasa/hass-nabucasa";
    changelog = "https://github.com/NabuCasa/hass-nabucasa/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      fab
      Scriptkiddi
    ];
  };
})
