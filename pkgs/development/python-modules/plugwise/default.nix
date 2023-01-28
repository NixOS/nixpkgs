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
  version = "0.27.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = "python-plugwise";
    rev = "refs/tags/v${version}";
    hash = "sha256-Ti0ZQlWsZaGvpfCTUnGNzdKcqKO84fAtlIUWC0wiyTI=";
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

  nativeCheckInputs = [
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
    changelog = "https://github.com/plugwise/python-plugwise/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
