{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, aiohttp
, xmltodict
, python-socketio
, websocket-client
}:

buildPythonPackage rec {
  pname = "pycontrol4";
  version = "1.1.0";

  disabled = pythonOlder "3.6";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "lawtancool";
    repo = "pyControl4";
    rev = "v${version}";
    hash = "sha256-dMv2b6dbMauPvPf4LHKmLF4jnXYRYe6A+2lDtiZDUhY=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "python-socketio>=4,<5" "python-socketio>=4"
  '';

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
