{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, numpy
, ffmpeg
, pkg-config
}:

buildPythonPackage rec {
  pname = "av";
  version = "8.0.3";
  disabled = isPy27; # setup.py no longer compatible

  src = fetchPypi {
    inherit pname version;
    sha256 = "521814309c91d526b6b5c9517018aef2dd12bc3d86351037db69aa67730692b8";
  };

  checkInputs = [ numpy ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ ffmpeg ];

  # Tests require downloading files from internet
  doCheck = false;

  meta = {
    description = "Pythonic bindings for FFmpeg/Libav";
    homepage = "https://github.com/mikeboers/PyAV/";
    license = lib.licenses.bsd2;
  };
}
