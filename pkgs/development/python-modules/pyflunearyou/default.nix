{ lib
, aiohttp
, aresponses
, aiocache
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytest-asyncio
, pytest-aiohttp
, pytestCheckHook
, pythonOlder
, msgpack
, ujson
}:

buildPythonPackage rec {
  pname = "pyflunearyou";
  version = "2.0.0";
  format = "pyproject";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = version;
    sha256 = "18vxwfyvicbx8idpa0h0alp4ygnwfph6g4kq93hfm0fc94gi6h94";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    aiohttp
    aiocache
    msgpack
    ujson
  ];

  checkInputs = [
    aresponses
    pytest-asyncio
    pytest-aiohttp
    pytestCheckHook
  ];

  # Ignore the examples directory as the files are prefixed with test_.
  # disabledTestFiles doesn't seem to work here
  pytestFlagsArray = [ "--ignore examples/" ];
  pythonImportsCheck = [ "pyflunearyou" ];

  meta = with lib; {
    description = "Python library for retrieving UV-related information from Flu Near You";
    homepage = "https://github.com/bachya/pyflunearyou";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
