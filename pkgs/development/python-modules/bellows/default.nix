{ lib, stdenv, buildPythonPackage, fetchFromGitHub
, click, click-log, pure-pcapy3
, pyserial-asyncio, voluptuous, zigpy
, asynctest, pytestCheckHook, pytest-asyncio }:

buildPythonPackage rec {
  pname = "bellows";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "bellows";
    rev = version;
    sha256 = "1gja7cb1cyzbi19k8awa2gyc3bjam0adapalpk5slxny0vxlc73a";
  };

  propagatedBuildInputs = [
    click click-log pure-pcapy3 pyserial-asyncio voluptuous zigpy
  ];

  checkInputs = [
    asynctest
    pytestCheckHook
    pytest-asyncio
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
