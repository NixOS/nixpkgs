{ stdenv, buildPythonPackage, fetchPypi
, aiohttp, zigpy
, pytest }:

buildPythonPackage rec {
  pname = "flux_led";
  version = "0.22";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ilmz2jfpgh08v7bm4fy7mp06vkg6a6zwqr8cr0dqbrn6jylr6x6";
  };

  meta = with stdenv.lib; {
    description = "A Python library to communicate with the flux_led smart bulbs";
    homepage = "https://github.com/Danielhiversen/flux_led";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ colemickens ];
    platforms = platforms.linux;
  };
}
