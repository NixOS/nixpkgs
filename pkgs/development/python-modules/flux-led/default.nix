{ stdenv, buildPythonPackage, fetchFromGitHub
, aiohttp, zigpy
, pytest, isPy27 }:

buildPythonPackage rec {
  pname = "flux_led";
  version = "0.22";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "flux_led";
    rev = version;
    sha256 = "1zgajlkhclyrqhkmivna4ha2lyvfpk5929s042gy59p7mzpkvjx7";
  };

  meta = with stdenv.lib; {
    description = "A Python library to communicate with the flux_led smart bulbs";
    homepage = "https://github.com/Danielhiversen/flux_led";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ colemickens ];
    platforms = platforms.linux;
  };
}
