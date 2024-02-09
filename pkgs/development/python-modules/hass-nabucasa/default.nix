{ lib
, acme
, aiohttp
, atomicwrites-homeassistant
, attrs
, buildPythonPackage
, ciso8601
, cryptography
, fetchFromGitHub
, pycognito
, pytest-aiohttp
, pytest-timeout
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
, setuptools
, snitun
, syrupy
, xmltodict
}:

buildPythonPackage rec {
  pname = "hass-nabucasa";
  version = "0.75.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "nabucasa";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-VQ5nxkrHt6xp+bk/wqAPJ+srTuf9WyamoLXawW1mKWo=";
  };

  nativeBuildInputs = [
    setuptools
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "acme"
  ];

  propagatedBuildInputs = [
    acme
    aiohttp
    atomicwrites-homeassistant
    attrs
    ciso8601
    cryptography
    pycognito
    snitun
  ];

  nativeCheckInputs = [
    pytest-aiohttp
    pytest-timeout
    pytestCheckHook
    syrupy
    xmltodict
  ];

  pythonImportsCheck = [
    "hass_nabucasa"
  ];

  meta = with lib; {
    homepage = "https://github.com/NabuCasa/hass-nabucasa";
    description = "Python module for the Home Assistant cloud integration";
    changelog = "https://github.com/NabuCasa/hass-nabucasa/releases/tag/${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ Scriptkiddi ];
  };
}
