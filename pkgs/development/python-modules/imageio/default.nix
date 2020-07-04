{ stdenv
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
, futures
, enum34
}:

buildPythonPackage rec {
  pname = "imageio";
  version = "2.8.0";
  disabled = isPy27;

  src = fetchPypi {
    sha256 = "fb5fd6d3d17126bbaac9af29fe340e2c97a196eb9416d4f28c0e543744a152cf";
    inherit pname version;
  };

  checkInputs = [ pytest psutil ] ++ stdenv.lib.optionals isPy3k [
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

  meta = with stdenv.lib; {
    description = "Library for reading and writing a wide range of image, video, scientific, and volumetric data formats";
    homepage = "http://imageio.github.io/";
    license = licenses.bsd2;
  };

}
