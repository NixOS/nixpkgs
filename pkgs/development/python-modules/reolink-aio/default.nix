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
  version = "0.8.1";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "starkillerOG";
    repo = "reolink_aio";
    rev = "refs/tags/${version}";
    hash = "sha256-zxIx7+cpYKN811yz+nxjtOagHOMMIs1YU0ZLN9q5T7M=";
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
