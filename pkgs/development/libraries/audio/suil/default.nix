{ stdenv, fetchurl, gtk, lv2, pkgconfig, python, serd, sord, sratom, qt4 }:

stdenv.mkDerivation rec {
  name = "suil-${version}";
  version = "0.6.4";

  src = fetchurl {
    url = "http://download.drobilla.net/${name}.tar.bz2";
    sha256 = "12pz2w74rhhi6gsskfs6l71vw8qfz8906kbjf5w6jyy1x4kkdca2";
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
