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
  version = "5.0.4";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = version;
    sha256 = "0z769xrb6w6bhqcq02sjryl1qyvk9dc1xfn06fc3mdqnrbr0xxj3";
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
