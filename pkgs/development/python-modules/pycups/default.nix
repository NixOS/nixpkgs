{stdenv, fetchurl, python, cups}:

stdenv.mkDerivation {
  name = "pycups-1.9.45";
  src = fetchurl {
    url = http://cyberelk.net/tim/data/pycups/pycups-1.9.45.tar.bz2;
    md5 = "ff634a6751f8a859ed26751bf03abef0";
  };
  installPhase = "python ./setup.py install --prefix $out";
  buildInputs = [ python cups ];
}
