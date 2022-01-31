{ lib
, buildPythonPackage
, isPy27
, fetchPypi
, imageio-ffmpeg
, numpy
, pillow
, psutil
, pytestCheckHook
, tifffile
}:

buildPythonPackage rec {
  pname = "imageio";
  version = "2.13.2";
  disabled = isPy27;

  src = fetchPypi {
    sha256 = "5b7a55d07de88a2fd70f18a1608ca05ba2b55596a942fb2c390240201009a6c3";
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
    tifffile
  ];

  preCheck = ''
    export IMAGEIO_USERDIR="$TMP"
    export IMAGEIO_NO_INTERNET="true"
    export HOME="$(mktemp -d)"
  '';

  disabledTests = [
    # tries to pull remote resources, even with IMAGEIO_NO_INTERNET
    "test_png_remote"
    # needs git history
    "test_mvolread_out_of_bytes"
    "test_imiter"
    "test_memory_size"
    "test_legacy_write_empty"
  ];

  disabledTestPaths = [
    "tests/test_pillow.py"
  ];

  meta = with lib; {
    description = "Library for reading and writing a wide range of image, video, scientific, and volumetric data formats";
    homepage = "http://imageio.github.io/";
    license = licenses.bsd2;
  };
}
