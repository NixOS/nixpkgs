{ lib
, buildPythonPackage
, fetchFromGitHub
, click
, click-log
, pure-pcapy3
, pyserial-asyncio
, voluptuous
, zigpy
, asynctest
, pytestCheckHook
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "bellows";
  version = "0.23.1";

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "bellows";
    rev = version;
    sha256 = "sha256-c9rKRmGMlYrzVQmUuM9P3c/Jm4QVM2aBRSZ0OkyrPTY=";
  };

  prePatch = ''
    substituteInPlace setup.py \
      --replace "click-log==0.2.1" "click-log>=0.2.1"
  '';

  propagatedBuildInputs = [
    click
    click-log
    pure-pcapy3
    pyserial-asyncio
    voluptuous
    zigpy
  ];

  checkInputs = [
    asynctest
    pytestCheckHook
    pytest-asyncio
  ];

  meta = with lib; {
    description = "A Python 3 project to implement EZSP for EmberZNet devices";
    homepage = "https://github.com/zigpy/bellows";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ etu mvnetbiz ];
  };
}
