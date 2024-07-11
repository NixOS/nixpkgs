{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  xmltodict,
  python-socketio,
  websocket-client,
}:

buildPythonPackage rec {
  pname = "pycontrol4";
  version = "1.1.2";

  disabled = pythonOlder "3.6";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "lawtancool";
    repo = "pyControl4";
    rev = "refs/tags/v${version}";
    hash = "sha256-oKKc9s3/fO7cFMjOeKtpvEwmfglxI2lxlN3EIva7zR8=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "python-socketio>=4,<5" "python-socketio>=4"
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    aiohttp
    xmltodict
    python-socketio
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
    description = "Python 3 asyncio package for interacting with Control4 systems";
    homepage = "https://github.com/lawtancool/pyControl4";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
