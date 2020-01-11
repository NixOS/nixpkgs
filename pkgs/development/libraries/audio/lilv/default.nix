{ stdenv, fetchurl, lv2, pkgconfig, python3, serd, sord, sratom, wafHook }:

stdenv.mkDerivation rec {
  pname = "lilv";
  version = "0.24.4";

  src = fetchurl {
    url = "https://download.drobilla.net/${pname}-${version}.tar.bz2";
    sha256 = "0f24cd7wkk5l969857g2ydz2kjjrkvvddg1g87xzzs78lsvq8fy3";
  };

  nativeBuildInputs = [ pkgconfig python3 wafHook ];
  buildInputs = [ lv2 serd sord sratom ];

  meta = with stdenv.lib; {
    homepage = http://drobilla.net/software/lilv;
    description = "A C library to make the use of LV2 plugins";
    license = licenses.mit;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
