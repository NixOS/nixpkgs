{stdenv, fetchurl, python}:

assert stdenv.system == "i686-linux";

stdenv.mkDerivation {
  name = "psyco-1.5.2";
  src = fetchurl {
    url = mirror://sourceforge/psyco/psyco-1.5.2-src.tar.gz;
    md5 = "bceb17423d06b573dc7b875d34e79417";
  };
  buildInputs = [python];
  buildPhase = "true";
  installPhase = "python ./setup.py install --prefix=$out";
}
