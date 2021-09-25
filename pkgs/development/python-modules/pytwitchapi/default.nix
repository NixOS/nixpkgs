{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, aiohttp
, python-dateutil
, requests
, websockets
}:

buildPythonPackage rec {
  pname = "pytwitchapi";
  version = "2.4.2";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Teekeks";
    repo = "pyTwitchAPI";
    rev = "v${version}";
    sha256 = "0fq1ky6nbrb47mlznl3vq8m86lqb6p78fvbcy8x3rm3m5zngxnz7";
  };

  propagatedBuildInputs = [
    aiohttp
    python-dateutil
    requests
    websockets
  ];

  # Project has no tests.
  doCheck = false;

  pythonImportsCheck = [ "twitchAPI" ];

  meta = with lib; {
    description = "Python implementation of the Twitch Helix API, its Webhook and PubSub";
    homepage = "https://github.com/Teekeks/pyTwitchAPI";
    license = licenses.mit;
    maintainers = with maintainers; [ wolfangaukang ];
  };
}
