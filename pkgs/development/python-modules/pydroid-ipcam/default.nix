{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, yarl
}:

buildPythonPackage rec {
  pname = "pydroid-ipcam";
  version = "unstable-2021-06-01";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = pname;
    rev = "3ca14ff178f3506a6a91d8736deea8f06e9ad1c1";
    sha256 = "0w81pl5fya17hg5xgba2vgxnylfd8jc70il575wdz2pw6z6ihj3s";
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
