{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, aiohttp
, pydantic
, freezegun
, pytest-aiohttp
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "gcal-sync";
  version = "0.11.0";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "allenporter";
    repo = "gcal_sync";
    rev = "refs/tags/${version}";
    hash = "sha256-7eaAgGVPzBc2A57VAlLZvz+SYl8G7hv2iCDAOh8Gmoc=";
  };

  propagatedBuildInputs = [
    aiohttp
    pydantic
  ];

  checkInputs = [
    freezegun
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "gcal_sync" ];

  meta = {
    description = "Python library for syncing Google Calendar to local storage";
    homepage = "https://github.com/allenporter/gcal_sync";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
