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
  fetchpatch2,
  pycognito,
  pyjwt,
  pytest-aiohttp,
  pytest-timeout,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  snitun,
  syrupy,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "hass-nabucasa";
  version = "0.82.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "nabucasa";
    repo = "hass-nabucasa";
    rev = "refs/tags/${version}";
    hash = "sha256-hRhRXpiIPrI3umOhsVWLwkSwtEfwevC3fNvJElhKy+I=";
  };

  patches = [
    (fetchpatch2 {
      name = "aiohttp-3.10.6-compat.patch";
      url = "https://github.com/NabuCasa/hass-nabucasa/commit/b53bc12924ca6260583e250f49f663b2d1c11541.patch";
      hash = "sha256-Z5vTl0zuidFIo92Po8oLB0VfMC7c6mlq/mJkeHXOSpQ=";
    })
  ];

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
    changelog = "https://github.com/NabuCasa/hass-nabucasa/releases/tag/${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ Scriptkiddi ];
  };
}
