{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, pkg-config
, ffmpeg
, libvpx
, libopus
, srtp
, av
, cryptography
, numpy
, pyee
, dnspython
, netifaces
, google-crc32c
, pyopenssl
, aioice
, pylibsrtp
, audioop-lts
, pythonAtLeast
}:
buildPythonPackage rec {
  pname = "aiortc";
  version = "1.5.0";
  pyproject = true;
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-grQTHYT4YuJOHDVQtz94QSzJVUFAoldVd+s/BGdbutI=";
  };
  nativeBuildInputs = [ setuptools pkg-config ];
  buildInputs = [ ffmpeg libvpx libopus srtp ];
  propagatedBuildInputs = [
    av
    cryptography
    numpy
    pyee
    dnspython
    netifaces
    google-crc32c
    pyopenssl
    aioice
    pylibsrtp
  ] ++ lib.optionals (pythonAtLeast "3.13") [
    audioop-lts
  ];
  pythonImportsCheck = [ "aiortc" ];
  dontCheckRuntimeDeps = true; # Avoid runtime dependency checks that may fail due to missing ffmpeg or other media libraries.
  meta = {
    description = "WebRTC and ORTC implementation for Python using asyncio";
    homepage = "https://github.com/aiortc/aiortc";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sdubey ];
  };
}