{ stdenv, fetchurl, lv2, pkgconfig, python, serd, sord, sratom }:

stdenv.mkDerivation rec {
  name = "lilv-${version}";
  version = "0.18.0";

  src = fetchurl {
    url = "http://download.drobilla.net/${name}.tar.bz2";
    sha256 = "1k9wfc08ylgbkwbnvh1fx1bdzl3y59xrrx8gv0vk68yzcvcmv6am";
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
    platforms = platforms.linux;
  };
}
