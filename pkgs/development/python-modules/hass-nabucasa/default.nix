{ lib, buildPythonPackage, fetchFromGitHub
, acme, aiohttp, snitun, attrs, pycognito, warrant
, pytest-aiohttp, asynctest, atomicwrites, pytest }:

buildPythonPackage rec {
  pname = "hass-nabucasa";
  version = "0.39.0";

  src = fetchFromGitHub {
    owner = "nabucasa";
    repo = pname;
    rev = version;
    sha256 = "1bsvwxddpp4dsq3k2320qrx5x9lscqzffzz1zj6fbwgc4741f01w";
  };

  postPatch = ''
    sed -i 's/"acme.*"/"acme"/' setup.py
    sed -i 's/"attrs.*"/"attrs"/' setup.py
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
