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
  version = "8.1.0";
  disabled = isPy27; # setup.py no longer compatible

  src = fetchPypi {
    inherit pname version;
    sha256 = "0402169bc27e38e0f44e0e0e1854cf488337e86206b6d25d6dae2bfd7a1a0230";
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
