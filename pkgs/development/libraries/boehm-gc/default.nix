{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "boehm-gc-7.0";
  src = fetchurl {
    url = http://www.hpl.hp.com/personal/Hans_Boehm/gc/gc_source/gc-7.0.tar.gz;
    sha256 = "0nqy0462ainp79fjmx5lgr89s2d433fggr3n9d1p09xq77lwc2nj";
  };
  meta = {
    description = "A garbage collector for C and C++";
    homepage = http://www.hpl.hp.com/personal/Hans_Boehm/gc/;
  };
}
