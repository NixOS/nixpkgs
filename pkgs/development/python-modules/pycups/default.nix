{stdenv, fetchurl, python, cups}:

let
  version = "1.9.49";
in
stdenv.mkDerivation {
  name = "pycups-${version}";
  src = fetchurl {
    url = "http://cyberelk.net/tim/data/pycups/pycups-${version}.tar.bz2";
    sha256 = "1gpp28sknjw5z4mzhaifc6hkfrlbm2y6w870q47ia8amnm05d3pk";
  };
  buildPhase = "";
  installPhase = ''
    CFLAGS=-DVERSION=\\\"${version}\\\" python ./setup.py install --prefix $out
  '';
  buildInputs = [ python cups ];
}
