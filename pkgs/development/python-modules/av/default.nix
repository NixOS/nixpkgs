{ lib
, buildPythonPackage
, fetchPypi
, numpy
, ffmpeg_4
, pkgconfig
}:

buildPythonPackage rec {
  pname = "av";
  version = "7.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "10qav9dryly9h6n8vypx5m334v2lh88fsvgfg0zjy4bxjslay4zv";
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
