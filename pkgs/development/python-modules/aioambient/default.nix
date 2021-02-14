{ lib
, aiohttp
, aresponses
, asynctest
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytest-asyncio
, pytest-cov
, pytestCheckHook
, python-engineio
, python-socketio
, pythonOlder
, websockets
}:

buildPythonPackage rec {
  pname = "aioambient";
  version = "1.2.3";
  format = "pyproject";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = version;
    sha256 = "1jg93rjn1gxc66qmipw4z1c09l8hgfsydacjgkfjq7vg547lragp";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    aiohttp
    python-engineio
    python-socketio
    websockets
  ];

  checkInputs = [
    aresponses
    asynctest
    pytest-asyncio
    pytest-cov
    pytestCheckHook
  ];

  # Ignore the examples directory as the files are prefixed with test_
  pytestFlagsArray = [ "--ignore examples/" ];
  pythonImportsCheck = [ "aioambient" ];

  meta = with lib; {
    description = "Python library for the Ambient Weather API";
    homepage = "https://github.com/bachya/aioambient";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
