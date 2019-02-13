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
  version = "6.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0h5d6yy6mjaflzh9z8fv3j1rjwijmzqfrpz88zxk0qfmbprdc91z";
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
