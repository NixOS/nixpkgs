{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, websockets
}:

buildPythonPackage rec {
  pname = "aiowebostv";
  version = "0.1.3";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-UKDcIo0jhI84WDcSK3fciRqzKjHwbZXkqHjdo7Xt4iE=";
  };

  propagatedBuildInputs = [
    websockets
  ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "aiowebostv"
  ];

  meta = with lib; {
    description = "Module to interact with LG webOS based TV devices";
    homepage = "https://github.com/home-assistant-libs/aiowebostv";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
