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
  version = "2.0.2";
  format = "pyproject";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = version;
    sha256 = "07n2dvnfpfglpdlnwzj4dy41x2zc07ia2krvxdarnv8wzap30y23";
  };

  nativeBuildInputs = [
    poetry-core
  ];

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
  disabledTestPaths = [ "examples/" ];

  pythonImportsCheck = [ "pyflunearyou" ];

  meta = with lib; {
    description = "Python library for retrieving UV-related information from Flu Near You";
    homepage = "https://github.com/bachya/pyflunearyou";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
