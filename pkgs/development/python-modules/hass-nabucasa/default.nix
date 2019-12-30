{ lib, buildPythonPackage, fetchFromGitHub, fetchpatch, acme, aiohttp, snitun, attrs, pytest-aiohttp, warrant, pytest }:

buildPythonPackage rec {
  pname = "hass-nabucasa";
  version = "0.29";

  src = fetchFromGitHub {
    owner = "nabucasa";
    repo = pname;
    rev = version;
    sha256 = "182nh5i3hlj0kqkbynk69md0ddq83w02l8lz4m03d8xbjixzi1k1";
  };

  # upstreamed in https://github.com/NabuCasa/hass-nabucasa/pull/119
  postPatch = ''
    sed -i 's/"acme.*/"acme>=0.40.0,<2.0"/' setup.py
    cat setup.py
  '';

  propagatedBuildInputs = [ acme aiohttp snitun attrs warrant ];

  checkInputs = [ pytest pytest-aiohttp ];

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
