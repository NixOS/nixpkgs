{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, freezegun
, ical
, pydantic
, pytest-aiohttp
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "gcal-sync";
  version = "4.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "allenporter";
    repo = "gcal_sync";
    rev = "refs/tags/${version}";
    hash = "sha256-Z5XRyhObREj38BWnexQnwHS1y2Ewyv5/KPkl/ybHvUE=";
  };

  propagatedBuildInputs = [
    aiohttp
    ical
    pydantic
  ];

  nativeCheckInputs = [
    freezegun
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "gcal_sync"
  ];

  meta = with lib; {
    description = "Library for syncing Google Calendar to local storage";
    homepage = "https://github.com/allenporter/gcal_sync";
    changelog = "https://github.com/allenporter/gcal_sync/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
