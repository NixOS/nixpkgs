{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, websockets
}:

buildPythonPackage rec {
  pname = "aiowebostv";
  version = "0.3.2";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-SNrznJY/HKUhDsClpC4j6Z/qE9qOsrdfc7Fu0W8ru/c=";
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
    changelog = "https://github.com/home-assistant-libs/aiowebostv/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
