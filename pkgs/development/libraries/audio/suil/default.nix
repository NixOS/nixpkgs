{ stdenv, fetchurl, gtk, lv2, pkgconfig, python, serd, sord, sratom, qt4 }:

stdenv.mkDerivation rec {
  name = "suil-${version}";
  version = "0.6.16";

  src = fetchurl {
    url = "http://download.drobilla.net/${name}.tar.bz2";
    sha256 = "101xq7pd8kvnqwm4viaj4ikhn65jxrlrkg79ca954yqrdb9p9w8v";
  };

  buildInputs = [ gtk lv2 pkgconfig python qt4 serd sord sratom ];

  configurePhase = "python waf configure --prefix=$out";

  buildPhase = "python waf";

  installPhase = "python waf install";

  meta = with stdenv.lib; {
    homepage = http://drobilla.net/software/suil;
    description = "A lightweight C library for loading and wrapping LV2 plugin UIs";
    license = licenses.mit;
    maintainers = [ maintainers.goibhniu ];

  };
}
