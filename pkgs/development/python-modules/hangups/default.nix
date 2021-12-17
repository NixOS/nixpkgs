{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, configargparse
, aiohttp
, async-timeout
, appdirs
, readlike
, requests
, reparser
, protobuf
, urwid
, mechanicalsoup
, httpretty
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "hangups";
  version = "0.4.15";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "tdryer";
    repo = "hangups";
    rev = "v${version}";
    sha256 = "sha256-47OvfFK92AtX6KiYnvro2B17RfQWyzgsgvOfl5T3Kag=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "protobuf>=3.1.0,<3.17" "protobuf" \
      --replace "async-timeout>=2,<4" "async-timeout" \
      --replace "MechanicalSoup>=0.6.0,<0.13" "MechanicalSoup"
  '';

  propagatedBuildInputs = [
    configargparse
    aiohttp
    async-timeout
    appdirs
    readlike
    requests
    reparser
    protobuf
    urwid
    mechanicalsoup
  ];

  checkInputs = [
    httpretty
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "hangups"
    "hangups.client"
    "hangups.event"
    "hangups.parsers"
    "hangups.user"
  ];

  meta = with lib; {
    description = "The first third-party instant messaging client for Google Hangouts";
    homepage = "https://github.com/tdryer/hangups";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
