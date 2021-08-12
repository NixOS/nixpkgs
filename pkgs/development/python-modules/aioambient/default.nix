{ lib
, aiohttp
, aresponses
, asynctest
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytest-aiohttp
, pytest-asyncio
, pytestCheckHook
, python-engineio
, python-socketio
, pythonOlder
, websockets
}:

buildPythonPackage rec {
  pname = "aioambient";
  version = "1.2.6";
  format = "pyproject";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = version;
    sha256 = "sha256-EppnuZP62YTFI3UJUzBUj2m5TvFh1WiDz9smHY7We60=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    python-engineio
    python-socketio
    websockets
  ];

  checkInputs = [
    aresponses
    asynctest
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
  ];

  # Ignore the examples directory as the files are prefixed with test_
  disabledTestPaths = [ "examples/" ];

  pythonImportsCheck = [ "aioambient" ];

  meta = with lib; {
    description = "Python library for the Ambient Weather API";
    homepage = "https://github.com/bachya/aioambient";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
