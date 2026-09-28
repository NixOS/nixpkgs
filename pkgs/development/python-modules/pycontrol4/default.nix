{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  xmltodict,
  python-socketio-v4,
  websocket-client,
}:

buildPythonPackage rec {
  pname = "pycontrol4";
  version = "2.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lawtancool";
    repo = "pyControl4";
    tag = "v${version}";
    hash = "sha256-4qgyn2ekxo0pjPixfNpRqHE+jgsNQGk9fbESbUTDxMg=";
  };

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

  meta = {
    changelog = "https://github.com/lawtancool/pyControl4/releases/tag/v${version}";
    description = "Python 3 asyncio package for interacting with Control4 systems";
    homepage = "https://github.com/lawtancool/pyControl4";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
