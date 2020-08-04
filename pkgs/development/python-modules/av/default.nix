{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, numpy
, ffmpeg
, pkgconfig
}:

buildPythonPackage rec {
  pname = "av";
  version = "8.0.2";
  disabled = isPy27; # setup.py no longer compatible

  src = fetchPypi {
    inherit pname version;
    sha256 = "a3bba6bf68766b8a1a057f28869c7078cf0a1ec3207c7788c2ce8fe6f6bd8267";
  };

  checkInputs = [ numpy ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ffmpeg ];

  # Tests require downloading files from internet
  doCheck = false;

  meta = {
    description = "Pythonic bindings for FFmpeg/Libav";
    homepage = "https://github.com/mikeboers/PyAV/";
    license = lib.licenses.bsd2;
  };
}
