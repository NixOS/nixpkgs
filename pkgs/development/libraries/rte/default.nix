{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "rte-0.5.2";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/zapping/rte-0.5.2.tar.bz2;
    md5 = "152d5d81169f0c9a543078543e354ebe";
  };
}
