{ stdenv, buildPythonPackage, fetchPypi
, click, click-log, pure-pcapy3
, pyserial, pyserial-asyncio, voluptuous, zigpy
, asynctest, pytest, pytest-asyncio }:

let
  pname = "bellows";
  version = "0.20.3";

in buildPythonPackage rec {
  inherit pname version;

  src = fetchPypi {
    inherit pname version;
    sha256 = "9342b6b9423c818f99f7c6d9086fbb5e27d5c2efbb1f2a08f6f5a917c4991f86";
  };

  propagatedBuildInputs = [
    click click-log pure-pcapy3 pyserial pyserial-asyncio voluptuous zigpy
  ];

  checkInputs = [
    asynctest pytest pytest-asyncio
  ];

  prePatch = ''
    substituteInPlace setup.py \
      --replace "click-log==0.2.0" "click-log>=0.2.0"
  '';

  meta = with stdenv.lib; {
    description = "A Python 3 project to implement EZSP for EmberZNet devices";
    homepage = "https://github.com/zigpy/bellows";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ etu mvnetbiz ];
  };
}
