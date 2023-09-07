{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, orjson
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "reolink-aio";
  version = "0.7.9";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "starkillerOG";
    repo = "reolink_aio";
    rev = "refs/tags/${version}";
    hash = "sha256-+1FZzgVaj2hphSTFlOtaYH3o++kC/aaahU8i8urdme0=";
  };

  propagatedBuildInputs = [
    aiohttp
    orjson
    typing-extensions
  ];

  pythonImportsCheck = [
    "reolink_aio"
  ];

  # All tests require a network device
  doCheck = false;

  meta = with lib; {
    description = "Module to interact with the Reolink IP camera API";
    homepage = "https://github.com/starkillerOG/reolink_aio";
    changelog = "https://github.com/starkillerOG/reolink_aio/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
