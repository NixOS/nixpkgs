{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "boehm-gc-6.8";
  src = fetchurl {
    url = http://www.hpl.hp.com/personal/Hans_Boehm/gc/gc_source/gc6.8.tar.gz;
    md5 = "418d38bd9c66398386a372ec0435250e";
  };
}
