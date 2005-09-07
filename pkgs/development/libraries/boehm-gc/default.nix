{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "boehm-gc-6.5";
  src = fetchurl {
    url = http://www.hpl.hp.com/personal/Hans_Boehm/gc/gc_source/gc6.5.tar.gz;
    md5 = "00bf95cdcbedfa7321d14e0133b31cdb";
  };
}
