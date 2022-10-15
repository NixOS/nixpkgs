 { lib
, aiohttp
, async-timeout
, buildPythonPackage
, crcmod
, defusedxml
, fetchFromGitHub
, freezegun
, jsonpickle
, munch
, mypy
, pyserial
, pytest-aiohttp
, pytest-asyncio
, pytestCheckHook
, python-dateutil
, pythonOlder
, pytz
, semver
}:

buildPythonPackage rec {
  pname = "plugwise";
  version = "0.25.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = "python-plugwise";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-7LwQwtzNLB9dvV79CFBNdC5I8uw+BP+H108ljacQjgY=";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
    crcmod
    defusedxml
    munch
    pyserial
    python-dateutil
    pytz
    semver
  ];

  checkInputs = [
    freezegun
    jsonpickle
    mypy
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "plugwise"
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Python module for Plugwise Smiles, Stretch and USB stick";
    homepage = "https://github.com/plugwise/python-plugwise";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
