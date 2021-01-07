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

  pytestFlagsArray = [
    "tests"
  ];

  meta = with lib; {
    description = "A simple, clean, well-tested Python library for interacting with AirVisual©";
    license = licenses.mit;
    homepage = "https://github.com/bachya/pyairvisual";
  };
}
