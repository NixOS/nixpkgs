{ lib
, buildPythonPackage
, fetchPypi
, numpy
, ffmpeg_4
, pkgconfig
}:

buildPythonPackage rec {
  pname = "av";
  version = "8.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a3bba6bf68766b8a1a057f28869c7078cf0a1ec3207c7788c2ce8fe6f6bd8267";
  };

  checkInputs = [ numpy ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ffmpeg_4 ];

  # Tests require downloading files from internet
  doCheck = false;

  meta = {
    description = "Pythonic bindings for FFmpeg/Libav";
    homepage = "https://github.com/mikeboers/PyAV/";
    license = lib.licenses.bsd2;
  };
}
