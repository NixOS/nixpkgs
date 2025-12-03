{
  lib,
  buildPythonPackage,
  setuptools,
  aioice,
  av,
  cffi,
  cryptography,
  google-crc32c,
  pyee,
  pylibsrtp,
  pyopenssl,
  libopus,
  libvpx,
  ifaddr,
  dnspython,
  fetchFromGitHub,
  pytestCheckHook,
  numpy,
}:

buildPythonPackage rec {
  pname = "aiortc";
  version = "1.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aiortc";
    repo = "aiortc";
    tag = version;
    hash = "sha256-ZgxSaiKkJrA5XvUT1zq8kwqB8mOvn46vLWXHyJSsHbM=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    aioice
    av
    cffi
    cryptography
    google-crc32c
    pyee
    pylibsrtp
    pyopenssl
    libopus
    libvpx
    ifaddr
    dnspython
  ];

  nativeCheckInputs = [
    numpy
    pytestCheckHook
  ];
  disabledTestPaths = [
    "tests/test_ortc.py" # hangs on: aiortc.rtcicetransport:rtcicetransport.py:365 RTCIceTransport(controlled) - new -> checking
    "tests/test_rtcicetransport.py" # hangs on: aiortc.rtcicetransport:rtcicetransport.py:365 RTCIceTransport(controlled) - new -> checking
    "tests/test_rtcpeerconnection.py" # fails
    "tests/test_contrib_signaling.py" # fails on darwin
  ];
  doCheck = true;
  pythonImportsCheck = [
    "aiortc"
  ];

  meta = {
    description = "WebRTC and ORTC implementation for Python using asyncio";
    homepage = "https://github.com/aiortc/aiortc";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ gesperon ];
  };
}
