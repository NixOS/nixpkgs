{ lib
, buildPythonPackage
, isPy27
, fetchPypi
, fetchpatch
, imageio-ffmpeg
, numpy
, pillow
, psutil
, pytestCheckHook
, tifffile
}:

buildPythonPackage rec {
  pname = "imageio";
  version = "2.13.5";
  disabled = isPy27;

  src = fetchPypi {
    sha256 = "0gc41aiz2i0napk1y00v9bgb4m7dd21sz3lghfm6w6s0ivjjpv67";
    inherit pname version;
  };

  patches = [
    # already present in master, remove on next bump
    (fetchpatch {
      name = "pillow-9-gif-rgba.patch";
      url = "https://github.com/imageio/imageio/commit/836b7a9b077a96de8adab5b67ea53b1292048275.patch";
      sha256 = "0rlyppa4w16n6qn5hr4wrg8xiy7ifs8c5dhmq8a9yncypx87glpv";
    })
  ];

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
