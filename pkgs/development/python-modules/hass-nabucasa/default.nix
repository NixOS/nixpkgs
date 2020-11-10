{ lib, buildPythonPackage, fetchFromGitHub, fetchpatch
, acme, aiohttp, snitun, attrs, pycognito, warrant
, pytest-aiohttp, asynctest, atomicwrites, pytest, pythonOlder }:

buildPythonPackage rec {
  pname = "hass-nabucasa";
  version = "0.37.1";

  src = fetchFromGitHub {
    owner = "nabucasa";
    repo = pname;
    rev = version;
    sha256 = "/GFNrLi1I69gUDIwnHa2q/pxkiRl9PKxpKtb56JrmuA=";
  };

  postPatch = ''
    sed -i 's/"acme.*"/"acme"/' setup.py
    sed -i 's/"cryptography.*"/"cryptography"/' setup.py
  '';

  propagatedBuildInputs = [
    acme aiohttp atomicwrites snitun attrs warrant pycognito
  ];

  checkInputs = [ pytest pytest-aiohttp asynctest ];

  checkPhase = ''
    pytest tests/
  '';

  meta = with lib; {
    homepage = "https://github.com/NabuCasa/hass-nabucasa";
    description = "Home Assistant cloud integration by Nabu Casa, inc.";
    license = licenses.gpl3;
    maintainers = with maintainers; [ Scriptkiddi ];
  };
}
