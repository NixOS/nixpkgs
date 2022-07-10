{ lib
, acme
, aiohttp
, asynctest
, atomicwrites-homeassistant
, attrs
, buildPythonPackage
, fetchFromGitHub
, pycognito
, pytest-aiohttp
, pytestCheckHook
, snitun
, warrant
}:

buildPythonPackage rec {
  pname = "hass-nabucasa";
  version = "0.54.1";

  src = fetchFromGitHub {
    owner = "nabucasa";
    repo = pname;
    rev = version;
    sha256 = "sha256-usxyONJZQOfLWtfuGUOOHL/Js2ROo7nODqgw++LgTis=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "acme==" "acme>=" \
      --replace "cryptography>=2.8,<37.0" "cryptography" \
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
    warrant
  ];

  doCheck = lib.versionAtLeast pytest-aiohttp.version "1.0.0";

  checkInputs = [
    asynctest
    pytest-aiohttp
    pytestCheckHook
  ];

  pythonImportsCheck = [ "hass_nabucasa" ];

  meta = with lib; {
    homepage = "https://github.com/NabuCasa/hass-nabucasa";
    description = "Python module for the Home Assistant cloud integration";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ Scriptkiddi ];
  };
}
