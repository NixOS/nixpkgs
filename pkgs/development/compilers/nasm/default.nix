{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "nasm-0.98.38";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/nasm/nasm-0.98.38.tar.bz2;
    md5 = "9f682490c132b070d54e395cb6ee145e";
  };
}
