{ stdenv, fetchurl, lv2, pkgconfig, python, serd, sord, sratom }:

stdenv.mkDerivation rec {
  name = "lilv-${version}";
  version = "0.16.0";

  src = fetchurl {
    url = "http://download.drobilla.net/${name}.tar.bz2";
    sha256 = "1ddrcikypi7gfmj5cqn975axzrgv7mhzif4h0ni9w5b4v64rvcyg";
  };

  buildInputs = [ lv2 pkgconfig python serd sord sratom ];

  configurePhase = "python waf configure --prefix=$out";

  buildPhase = "python waf";

  installPhase = "python waf install";

  meta = with stdenv.lib; {
    homepage = http://drobilla.net/software/lilv;
    description = "A C library to make the use of LV2 plugins";
    license = licenses.mit;
    maintainers = [ maintainers.goibhniu ];

  };
}
