{stdenv, fetchurl}: derivation {
  name = "libmad-0.15.0b";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/mad/libmad-0.15.0b.tar.gz;
    md5 = "2e4487cdf922a6da2546bad74f643205";
  };
  stdenv = stdenv;
}
