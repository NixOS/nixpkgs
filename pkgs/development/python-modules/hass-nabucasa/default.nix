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
  version = "0.66.2";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "nabucasa";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-LlVT5WRd2uhUaghThJ5ghPbX40QjqTenUC4txMx3Jlo=";
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
