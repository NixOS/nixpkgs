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
  version = "0.4.17";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "tdryer";
    repo = "hangups";
    rev = "v${version}";
    hash = "sha256-8kNWcRAip9LkmazDUVeDjGWhy/TWzT01c959LA5hb1Q=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "protobuf>=3.1.0,<3.20" "protobuf" \
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
