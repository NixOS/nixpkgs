{ stdenv, fetchurl, python, cups }:

let version = "1.9.57"; in

stdenv.mkDerivation {
  name = "pycups-${version}";
  
  src = fetchurl {
    url = "http://cyberelk.net/tim/data/pycups/pycups-${version}.tar.bz2";
    sha256 = "12m3lh4nmfp6yn6sqlskl9gb1mfiwx42m8dnms6j6xc2nimn5k14";
  };

  installPhase = ''
    CFLAGS=-DVERSION=\\\"${version}\\\" python ./setup.py install --prefix $out
  '';
  
  buildInputs = [ python cups ];
}
