{ lib
, aiohttp
, aiortsp
, buildPythonPackage
, fetchFromGitHub
, orjson
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "reolink-aio";
  version = "0.8.7";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "starkillerOG";
    repo = "reolink_aio";
    rev = "refs/tags/${version}";
    hash = "sha256-+Yhw7Wbt0K7BLXatd/UANnnNWPkxgk8SqAyV9Kk4hos=";
  };

  propagatedBuildInputs = [
    aiohttp
    aiortsp
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
