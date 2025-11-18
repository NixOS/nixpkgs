{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  xmltodict,
  python-socketio-v4,
  websocket-client,
}:

buildPythonPackage rec {
  pname = "pycontrol4";
  version = "1.5.0";

  disabled = pythonOlder "3.11";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "lawtancool";
    repo = "pyControl4";
    tag = "v${version}";
    hash = "sha256-r90v9vy8avvEbNKrzZgYtDS5Z5hV66Fd9fF9XJ4r7B4=";
  };

  patches = [
    # https://github.com/lawtancool/pyControl4/pull/47
    ./asyncio-timeout.patch
  ];

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    xmltodict
    python-socketio-v4
    websocket-client
  ];

  # tests access network
  doCheck = false;

  pythonImportsCheck = [
    "pyControl4.account"
    "pyControl4.alarm"
    "pyControl4.director"
    "pyControl4.light"
  ];

  meta = with lib; {
    changelog = "https://github.com/lawtancool/pyControl4/releases/tag/v${version}";
    description = "Python 3 asyncio package for interacting with Control4 systems";
    homepage = "https://github.com/lawtancool/pyControl4";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
