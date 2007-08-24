{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "rte-0.5.6";
  src = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/zapping/rte-0.5.6.tar.bz2;
    md5 = "6259cdff255af71c23a4576e7c5664a0";
  };
}
