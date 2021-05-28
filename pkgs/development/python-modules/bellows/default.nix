{ stdenv, buildPythonPackage, fetchPypi
, click, click-log, pure-pcapy3
, pyserial, pyserial-asyncio, voluptuous, zigpy
, asynctest, pytest, pytest-asyncio }:

let
  pname = "bellows";
  version = "0.18.1";

in buildPythonPackage rec {
  inherit pname version;

  src = fetchPypi {
    inherit pname version;
    sha256 = "6a2e323c2be6f10a8e99fffccb5670bc77bbddb7b5bd9253b69021120f2ab9d7";
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
