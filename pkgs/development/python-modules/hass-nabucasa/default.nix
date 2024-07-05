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
  pythonRelaxDepsHook,
  setuptools,
  snitun,
  syrupy,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "hass-nabucasa";
  version = "0.81.1";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "nabucasa";
    repo = "hass-nabucasa";
    rev = "refs/tags/${version}";
    hash = "sha256-/sY/JijBCcGcbMjoX0yuhFIWvU+TFVN8sRxBx+CDVVs=";
  };

  pythonRelaxDeps = [ "acme" ];

  nativeBuildInputs = [ pythonRelaxDepsHook ];

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
