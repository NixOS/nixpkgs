{ lib
, buildPythonPackage
, fetchPypi
, numpy
, ffmpeg_4
, libav
, pkgconfig
}:

buildPythonPackage rec {
  pname = "av";
  version = "6.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1wm33qajxcpl9rn7zfb2pwwqn87idb7ic7h5zwy2hgbpjnh3vc2g";
  };

  checkInputs = [ numpy ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ffmpeg_4 ];

  # Tests require downloading files from internet
  doCheck = false;

  meta = {
    description = "Pythonic bindings for FFmpeg/Libav";
    homepage = https://github.com/mikeboers/PyAV/;
    license = lib.licenses.bsd2;
  };
}
