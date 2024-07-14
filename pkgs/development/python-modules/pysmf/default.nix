{
  lib,
  buildPythonPackage,
  fetchPypi,
  pkg-config,
  libsmf,
  glib,
  pytest,
  cython,
}:

buildPythonPackage rec {
  pname = "pysmf";
  version = "0.1.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BiD5lZ3Y3uh2d0D/g8BT/z9uVbv2aacIfYOZ3vbeJ4I=";
  };

  postUnpack = ''
    rm $sourceRoot/src/smf.c
  '';

  nativeBuildInputs = [
    pkg-config
    pytest
    cython
  ];
  buildInputs = [
    libsmf
    glib
  ];

  meta = with lib; {
    homepage = "https://das.nasophon.de/pysmf/";
    description = "Python extension module for reading and writing Standard MIDI Files, based on libsmf";
    license = licenses.bsd2;
    maintainers = [ ];
  };
}
