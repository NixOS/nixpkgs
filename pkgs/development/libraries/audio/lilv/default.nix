{ stdenv, fetchurl, lv2, pkgconfig, python3, serd, sord, sratom, wafHook }:

stdenv.mkDerivation rec {
  pname = "lilv";
  version = "0.24.6";

  src = fetchurl {
    url = "https://download.drobilla.net/${pname}-${version}.tar.bz2";
    sha256 = "1p3hafsxgs5d4za7n66lf5nz74qssfqpmk520cm7iq2njvvlqm2z";
  };

  patches = [ ./lilv-pkgconfig.patch ];

  nativeBuildInputs = [ pkgconfig python3 wafHook ];
  buildInputs = [ serd sord sratom ];
  propagatedBuildInputs = [ lv2 ];

  meta = with stdenv.lib; {
    homepage = http://drobilla.net/software/lilv;
    description = "A C library to make the use of LV2 plugins";
    license = licenses.mit;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
