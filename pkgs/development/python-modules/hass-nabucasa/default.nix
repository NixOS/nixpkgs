{ lib, buildPythonPackage, fetchFromGitHub, fetchpatch
, acme, aiohttp, snitun, attrs, pycognito, warrant
, pytest-aiohttp, asynctest, atomicwrites, pytest, pythonOlder }:

buildPythonPackage rec {
  pname = "hass-nabucasa";
  version = "0.34.6";

  src = fetchFromGitHub {
    owner = "nabucasa";
    repo = pname;
    rev = version;
    sha256 = "1lkqwj58qr0vn7zf5mhrhaz973ahj9wjp4mgzvyja1gcdh6amv34";
  };

  postPatch = ''
    sed -i 's/"acme.*"/"acme"/' setup.py
  '';

  patches = [
    # relax pytz dependency
    (fetchpatch {
      url = "https://github.com/NabuCasa/hass-nabucasa/commit/419e80feddc36c68384c032feda0057515b53eaa.patch";
      sha256 = "14dgwci8615cwcf27hg7b42s7da50xhyjys3yx446q7ipk8zw4x6";
    })
  ];

  propagatedBuildInputs = [
    acme aiohttp atomicwrites snitun attrs warrant pycognito
  ];

  checkInputs = [ pytest pytest-aiohttp asynctest ];

  # Asynctest's mocking is broken with python3.8
  # https://github.com/Martiusweb/asynctest/issues/132
  doCheck = pythonOlder "3.8";

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
