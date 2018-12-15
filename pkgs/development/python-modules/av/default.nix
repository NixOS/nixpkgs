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
  version = "0.5.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0k5nbff8c2wxc8wnyn1qghndbd2rjck1y3552s63w41mccj1k1qr";
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
