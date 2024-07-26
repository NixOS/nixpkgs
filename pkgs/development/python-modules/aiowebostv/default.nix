{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  websockets,
}:

buildPythonPackage rec {
  pname = "aiowebostv";
  version = "0.4.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "aiowebostv";
    rev = "refs/tags/v${version}";
    hash = "sha256-RrSEl/U6UzPoE2151opDe0QRmj6M6wAtsQyF4/dd8ek=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ websockets ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "aiowebostv" ];

  meta = with lib; {
    description = "Module to interact with LG webOS based TV devices";
    homepage = "https://github.com/home-assistant-libs/aiowebostv";
    changelog = "https://github.com/home-assistant-libs/aiowebostv/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
