{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pytest-aiohttp
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "rtsp-to-webrtc";
  version = "0.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "allenporter";
    repo = "rtsp-to-webrtc-client";
    rev = version;
    hash = "sha256-ry6xNymWgkkvYXliVLUFOUiPz8gbCsQDrSuGmCaH4ZE=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  checkInputs = [
    pytest-aiohttp
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "rtsp_to_webrtc"
  ];

  meta = with lib; {
    description = "Module for RTSPtoWeb and RTSPtoWebRTC";
    homepage = "https://github.com/allenporter/rtsp-to-webrtc-client";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
