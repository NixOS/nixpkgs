{ lib
, buildPythonPackage
, isPy27
, pathlib
, fetchPypi
, pillow
, psutil
, imageio-ffmpeg
, pytest
, numpy
, isPy3k
, ffmpeg_3
, futures ? null
, enum34
}:

buildPythonPackage rec {
  pname = "imageio";
  version = "2.9.0";
  disabled = isPy27;

  src = fetchPypi {
    sha256 = "52ddbaeca2dccf53ba2d6dec5676ca7bc3b2403ef8b37f7da78b7654bb3e10f0";
    inherit pname version;
  };

  checkInputs = [ pytest psutil ] ++ lib.optionals isPy3k [
    imageio-ffmpeg ffmpeg_3
    ];
  propagatedBuildInputs = [ numpy pillow ];

  checkPhase = ''
    export IMAGEIO_USERDIR="$TMP"
    export IMAGEIO_NO_INTERNET="true"
    export HOME="$(mktemp -d)"
    py.test
  '';

  # For some reason, importing imageio also imports xml on Nix, see
  # https://github.com/imageio/imageio/issues/395

  # Also, there are tests that test the downloading of ffmpeg if it's not installed.
  # "Uncomment" those by renaming.
  postPatch = ''
    substituteInPlace tests/test_meta.py --replace '"urllib",' "\"urllib\",\"xml\","
    substituteInPlace tests/test_ffmpeg.py --replace 'test_get_exe_installed' 'get_exe_installed'
  '';

  meta = with lib; {
    description = "Library for reading and writing a wide range of image, video, scientific, and volumetric data formats";
    homepage = "http://imageio.github.io/";
    license = licenses.bsd2;
  };

}
