{stdenv, fetchurl, python, db4}:

stdenv.mkDerivation {
  name = "bsddb3-4.5.0";
  src = fetchurl {
    url = mirror://sourceforge/pybsddb/bsddb3-4.5.0.tar.gz;
    sha256 = "1h09kij32iikr9racp5p7qrb4li2gf2hs0lyq6d312qarja4d45v";
  };
  buildInputs = [python];
  buildPhase = "true";
  installPhase = "python ./setup.py install --prefix=$out --berkeley-db=${db4}";
}
