{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  yarl,
}:

buildPythonPackage rec {
  pname = "pydroid-ipcam";
  version = "3.0.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "pydroid-ipcam";
    tag = version;
    hash = "sha256-Z5dWgeXwIRd2iPT2GsWyypHVbaMZ5NUXEBxa8+AZdNk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    yarl
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pydroid_ipcam" ];

  meta = with lib; {
    description = "Python library for Android IP Webcam";
    homepage = "https://github.com/home-assistant-libs/pydroid-ipcam";
    changelog = "https://github.com/home-assistant-libs/pydroid-ipcam/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
