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
  pycognito,
  pyjwt,
  pytest-aiohttp,
  pytest-timeout,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  snitun,
  syrupy,
  webrtc-models,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "hass-nabucasa";
  version = "0.92.0";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "nabucasa";
    repo = "hass-nabucasa";
    tag = version;
    hash = "sha256-OwU3HxUj8M3/3Xv+9WPNbV8sVVR8S9u9U3mSK/P+4o8=";
  };

  pythonRelaxDeps = [ "acme" ];

  build-system = [ setuptools ];

  dependencies = [
    acme
    aiohttp
    atomicwrites-homeassistant
    attrs
    ciso8601
    cryptography
    pycognito
    pyjwt
    snitun
    webrtc-models
  ];

  nativeCheckInputs = [
    pytest-aiohttp
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
