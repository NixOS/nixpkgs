{ lib
, acme
, aiohttp
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
  version = "0.61.1";

  src = fetchFromGitHub {
    owner = "nabucasa";
    repo = pname;
    rev = version;
    hash = "sha256-xYcq1NZWyW3uZCDm2VesXr2f94ZnWbPj7YwpXrUkrWI=";
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
    warrant
  ];

  doCheck = lib.versionAtLeast pytest-aiohttp.version "1.0.0";

  nativeCheckInputs = [
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
