{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, yarl
}:

buildPythonPackage rec {
  pname = "pydroid-ipcam";
  version = "unstable-2021-04-16";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = pname;
    rev = "9f22682c6f9182aa5e42762f52223337b8b6909c";
    sha256 = "1lvppyzmwg0fp8zch11j51an4sb074yl9shzanakvjmbqpnif6s6";
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
