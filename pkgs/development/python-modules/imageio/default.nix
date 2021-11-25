{ lib
, buildPythonPackage
, isPy27
, fetchPypi
, imageio-ffmpeg
, numpy
, pillow
, psutil
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "imageio";
  version = "2.12.0";
  disabled = isPy27;

  src = fetchPypi {
    sha256 = "c416dd68328ace8536ff333cbb8927954036be56e201fed416e53e8f95e08a6c";
    inherit pname version;
  };

  propagatedBuildInputs = [
    imageio-ffmpeg
    numpy
    pillow
  ];

  checkInputs = [
    psutil
    pytestCheckHook
  ];

  preCheck = ''
    export IMAGEIO_USERDIR="$TMP"
    export IMAGEIO_NO_INTERNET="true"
    export HOME="$(mktemp -d)"
  '';

  meta = with lib; {
    description = "Library for reading and writing a wide range of image, video, scientific, and volumetric data formats";
    homepage = "http://imageio.github.io/";
    license = licenses.bsd2;
  };
}
