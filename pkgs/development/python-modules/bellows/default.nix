{ stdenv, buildPythonPackage, fetchPypi
, click, click-log, pure-pcapy3
, pyserial, pyserial-asyncio, voluptuous, zigpy
, asynctest, pytest, pytest-asyncio }:

let
  pname = "bellows";
  version = "0.17.0";

in buildPythonPackage rec {
  inherit pname version;

  src = fetchPypi {
    inherit pname version;
    sha256 = "03gckhrxji8lgjsi6xr8yql405kfanii5hjrmakk1328bmq9g5f6";
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
