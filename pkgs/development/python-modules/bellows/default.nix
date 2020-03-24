{ stdenv, buildPythonPackage, fetchPypi
, click-log, pyserial-asyncio, pure-pcapy3, zigpy, pyserial, pycryptodome
, voluptuous, aiohttp, crccheck }:

let
  pname = "bellows";
  version = "0.7.0";

in buildPythonPackage rec {
  inherit pname version;

  src = fetchPypi {
    inherit pname version;
    sha256 = "13590qafj7286nyjmki3rim07s64ccf90ag97cynwhxf8xxq8bkm";
  };

  buildInputs = [
    click-log pyserial-asyncio pure-pcapy3 zigpy pyserial pycryptodome
    voluptuous aiohttp crccheck
  ];

  prePatch = ''
    substituteInPlace setup.py \
      --replace "click-log==0.2.0" "click-log>=0.2.0"
  '';

  doCheck = false; # Tries to do requests to remote locations

  meta = with stdenv.lib; {
    description = "A Python 3 project to implement EZSP for EmberZNet devices";
    homepage = "https://github.com/zigpy/bellows";
    license = licenses.gpl3;
    maintainers = with maintainers; [ etu ];
  };
}
