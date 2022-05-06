{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, websockets
}:

buildPythonPackage rec {
  pname = "aiowebostv";
  version = "0.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-A7GiAQIuEXmCfo2pDJESCdAEaLumi1ACXnBMdGKwSvE=";
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
