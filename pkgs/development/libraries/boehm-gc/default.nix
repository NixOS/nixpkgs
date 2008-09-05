{stdenv, fetchurl}:

let version = "7.1"; in
stdenv.mkDerivation {
  name = "boehm-gc-${version}";

  src = fetchurl {
    url = "http://www.hpl.hp.com/personal/Hans_Boehm/gc/gc_source/gc-${version}.tar.gz";
    sha256 = "0c5zrsdw0rsli06lahcqwwz0prgah340fhfg7ggfgvz3iw1gdkp3";
  };

  doCheck = true;

  meta = {
    description = "A garbage collector for C and C++";
    homepage = http://www.hpl.hp.com/personal/Hans_Boehm/gc/;
  };
}
