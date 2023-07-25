{ lib
, acme
, aiohttp
, atomicwrites-homeassistant
, attrs
, buildPythonPackage
, fetchFromGitHub
, pycognito
, pytest-aiohttp
, pytest-timeout
, pytestCheckHook
, pythonOlder
, snitun
, syrupy
, xmltodict
}:

buildPythonPackage rec {
  pname = "hass-nabucasa";
  version = "0.69.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "nabucasa";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-7FO/z5AseP80y74e4ivLXlwB9t5jJf2bCaNp6HfqZ1c=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "acme==" "acme>=" \
      --replace "pycognito==" "pycognito>=" \
      --replace "snitun==" "snitun>=" \
  '';

  propagatedBuildInputs = [
    acme
    aiohttp
    atomicwrites-homeassistant
    attrs
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
