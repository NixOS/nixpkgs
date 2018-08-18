{ lib
, buildPythonPackage
, fetchPypi
, nose
, pillow
, numpy
, ffmpeg_2
, git
, libav
, pkgconfig
}:

buildPythonPackage rec {
  pname = "av";
  version = "0.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bf9a8d113392c6a445f424e16f9e64ac53d1db1548731e6326763d555647c24f";
  };

  buildInputs = [ nose pillow numpy ffmpeg_2 git libav pkgconfig ];

  # Because of https://github.com/mikeboers/PyAV/issues/152
  doCheck = false;

  meta = {
    description = "Pythonic bindings for FFmpeg/Libav";
    homepage = https://github.com/mikeboers/PyAV/;
    license = lib.licenses.bsd2;
  };
}