{
  lib,
  acme,
  aiohttp,
  atomicwrites-homeassistant,
  attrs,
  buildPythonPackage,
  ciso8601,
  cryptography,
  fetchFromGitHub,
  freezegun,
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
  webrtc-models,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "hass-nabucasa";
  version = "0.111.1";
  pyproject = true;

  disabled = pythonOlder "3.13";

  src = fetchFromGitHub {
    owner = "nabucasa";
    repo = "hass-nabucasa";
    tag = version;
    hash = "sha256-WmsLn/pHI3KJSmX5U20eNUEs0Q1upuwkkzcHIYPNYjY=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "acme"
    "josepy"
  ];

  dependencies = [
    acme
    aiohttp
    atomicwrites-homeassistant
    attrs
    ciso8601
    cryptography
    pycognito
    pyjwt
    sentence-stream
    snitun
    webrtc-models
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

  disabledTests = [
    # mock time 10800s (3h) vs 43200s (12h)
    "test_subscription_reconnection_handler_renews_and_starts"
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
