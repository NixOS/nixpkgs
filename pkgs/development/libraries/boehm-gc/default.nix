{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "boehm-gc-6.3";
  src = fetchurl {
    url = http://www.hpl.hp.com/personal/Hans_Boehm/gc/gc_source/gc6.3.tar.gz;
    md5 = "8b37ee18cbeb1dfd1866958e280db871";
  };
}
