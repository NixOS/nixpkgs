{ lib
, aiohttp
, aioresponses
, buildPythonPackage
, fetchFromGitHub
, orjson
, pytest-asyncio
, pytest-error-for-skips
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "nextdns";
  version = "1.2.2";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bieniu";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-F6vTOwE8WdcELH+W7VuRbGDLD+7+a09iai/TDMBfv4s=";
  };

  propagatedBuildInputs = [
    aiohttp
    orjson
  ];

  checkInputs = [
    aioresponses
    pytest-asyncio
    pytest-error-for-skips
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "nextdns"
  ];

  meta = with lib; {
    changelog = "https://github.com/bieniu/nextdns/releases/tag/${version}";
    description = "Module for the NextDNS API";
    homepage = "https://github.com/bieniu/nextdns";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
