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
  version = "0.2.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bdc7e2e213cb9041d9c5c0497e6f8c47e84f89f1f2673a46d891cca0fb0d19a0";
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