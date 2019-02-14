{ lib
, buildPythonPackage
, fetchPypi
, nose
, pillow
, numpy
, ffmpeg_4
, git
, libav
, pkgconfig
}:

buildPythonPackage rec {
  pname = "av";
  version = "6.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "eebbb56eeae650b1fc551f94d51aee39b487bf4df73c39daea186c5d2950650f";
  };

  buildInputs = [ nose pillow numpy ffmpeg_4 git pkgconfig ];

  # Tests require downloading files from internet
  doCheck = false;

  meta = {
    description = "Pythonic bindings for FFmpeg/Libav";
    homepage = https://github.com/mikeboers/PyAV/;
    license = lib.licenses.bsd2;
  };
}
