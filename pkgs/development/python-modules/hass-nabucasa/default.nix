{ lib, buildPythonPackage, fetchFromGitHub, fetchpatch
, acme, aiohttp, snitun, attrs, pycognito, warrant
, pytest-aiohttp, asynctest, pytest  }:

buildPythonPackage rec {
  pname = "hass-nabucasa";
  version = "0.32.2";

  src = fetchFromGitHub {
    owner = "nabucasa";
    repo = pname;
    rev = version;
    sha256 = "1hfi5q222kgbgrj5yvr4lbhca49hcs6sc2yhxc4pjxqsc12bv1f1";
  };

  # upstreamed in https://github.com/NabuCasa/hass-nabucasa/pull/119
  postPatch = ''
    sed -i 's/"acme.*/"acme>=0.40.0,<2.0"/' setup.py
    cat setup.py
  '';

  propagatedBuildInputs = [ acme aiohttp snitun attrs warrant pycognito ];

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
