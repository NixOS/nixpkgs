{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  yarl,
}:

buildPythonPackage rec {
  pname = "pydroid-ipcam";
  version = "3.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = pname;
    tag = version;
    hash = "sha256-Z5dWgeXwIRd2iPT2GsWyypHVbaMZ5NUXEBxa8+AZdNk=";
  };

  propagatedBuildInputs = [
    aiohttp
    yarl
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pydroid_ipcam" ];

  meta = with lib; {
    description = "Python library for Android IP Webcam";
    homepage = "https://github.com/home-assistant-libs/pydroid-ipcam";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
