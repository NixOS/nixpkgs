{ lib, stdenv, buildPythonPackage, fetchPypi
, click, click-log, pure-pcapy3
, pyserial, pyserial-asyncio, voluptuous, zigpy
, asynctest, pytest, pytest-asyncio }:

let
  pname = "bellows";
  version = "0.21.0";

in buildPythonPackage rec {
  inherit pname version;

  src = fetchPypi {
    inherit pname version;
    sha256 = "fd2ac40c1f3550580dc561ae58d7d15cfa12e6a7cc5d35ee80e7a1cb6a4cda4f";
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

  meta = with lib; {
    description = "A Python 3 project to implement EZSP for EmberZNet devices";
    homepage = "https://github.com/zigpy/bellows";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ etu mvnetbiz ];
  };
}
