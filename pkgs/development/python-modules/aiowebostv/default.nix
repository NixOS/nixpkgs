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
  version = "0.4.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "aiowebostv";
    rev = "refs/tags/v${version}";
    hash = "sha256-VUznW+rMCZF1LbrQmEaOgdcX3YCm6Tf7yWlB8KNrjxU=";
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
