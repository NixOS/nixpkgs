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
  version = "2021.10.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = version;
    sha256 = "sha256-DCh/o7p+lO5BhN3JoLdhImkzfxoyqiscA/6CwwvAnc0=";
  };

  postPatch = ''
    # https://github.com/bachya/aioambient/pull/97
    substituteInPlace pyproject.toml \
      --replace 'websockets = ">=8.1,<10.0"' 'websockets = ">=8.1,<11.0"'
  '';

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
  disabledTestPaths = [
    "examples/"
  ];

  pythonImportsCheck = [
    "aioambient"
  ];

  meta = with lib; {
    description = "Python library for the Ambient Weather API";
    homepage = "https://github.com/bachya/aioambient";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
