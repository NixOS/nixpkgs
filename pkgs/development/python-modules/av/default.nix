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
  version = "6.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9037d73d7a812c3dc75d9cc27d03215483c9e782eae63a07142c0725c6bd2df0";
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
