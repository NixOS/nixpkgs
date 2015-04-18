{ stdenv, fetchurl, python, cups }:

let version = "1.9.68"; in

stdenv.mkDerivation {
  name = "pycups-${version}";
  
  src = fetchurl {
    url = "http://cyberelk.net/tim/data/pycups/pycups-${version}.tar.bz2";
    sha256 = "1i1ph9k1wampa7r6mgc30a99w0zjmxhvcxjxrgjqa5vdknynqd24";
  };

  installPhase = ''
    CFLAGS=-DVERSION=\\\"${version}\\\" python ./setup.py install --prefix $out
  '';
  
  buildInputs = [ python cups ];
}
