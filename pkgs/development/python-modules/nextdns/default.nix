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
  version = "1.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bieniu";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-+ApchGB/+mV5i751jTfZoP8XJ3VAYPCwx6VoRkq5950=";
  };

  propagatedBuildInputs = [
    aiohttp
    orjson
  ];

  nativeCheckInputs = [
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
