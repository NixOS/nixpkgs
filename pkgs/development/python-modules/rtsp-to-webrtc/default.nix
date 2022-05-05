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
  version = "0.5.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "allenporter";
    repo = "rtsp-to-webrtc-client";
    rev = version;
    hash = "sha256-miMBN/8IO4v03mMoclCa3GFl6HCS3Sh6z2HOQ39MRZY=";
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
