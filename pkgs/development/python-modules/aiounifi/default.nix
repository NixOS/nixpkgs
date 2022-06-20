{ lib
, aiohttp
, aioresponses
, buildPythonPackage
, fetchFromGitHub
, pytest-aiohttp
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiounifi";
  version = "32";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Kane610";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-YKkZMOlV4DPScNohU+M2J71CrIT3cHCHrzp4PIOAc5E=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  checkInputs = [
    aioresponses
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "--asyncio-mode=auto"
  ];

  pythonImportsCheck = [
    "aiounifi"
  ];

  meta = with lib; {
    description = "Python library for communicating with Unifi Controller API";
    homepage = "https://github.com/Kane610/aiounifi";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
