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
  version = "2.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-toY3eVJdB5rbRuwkXMizpQUxUTo4Y1tWKFCZZuiYaGI=";
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
