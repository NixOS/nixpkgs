{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, poetry
, aiohttp
, numpy
, pysmb
, aresponses
, asynctest
, pytest-aiohttp
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyairvisual";
  version = "5.0.5";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = version;
    sha256 = "0jjvng3py5g97gvx6rdbk5zxbn5rw8gq1ki4qi4vfsypchxbpz2q";
  };

  nativeBuildInputs = [ poetry ];

  propagatedBuildInputs = [
    aiohttp
    numpy
    pysmb
  ];

  checkInputs = [
    aresponses
    asynctest
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
  ];

  # Ignore the examples as they are prefixed with test_
  pytestFlagsArray = [ "--ignore examples/" ];
  pythonImportsCheck = [ "pyairvisual" ];

  meta = with lib; {
    description = "Python library for interacting with AirVisual";
    homepage = "https://github.com/bachya/pyairvisual";
    changelog = "https://github.com/bachya/pyairvisual/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
