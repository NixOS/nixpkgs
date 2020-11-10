{ stdenv, fetchurl, lv2, pkgconfig, python3, serd, sord, sratom, wafHook }:

stdenv.mkDerivation rec {
  pname = "lilv";
  version = "0.24.8";

  src = fetchurl {
    url = "https://download.drobilla.net/${pname}-${version}.tar.bz2";
    sha256 = "0063i5zgf3d3accwmyx651hw0wh5ik7kji2hvfkcdbl1qia3dp6a";
  };

  patches = [ ./lilv-pkgconfig.patch ];

  nativeBuildInputs = [ pkgconfig python3 wafHook ];
  buildInputs = [ serd sord sratom ];
  propagatedBuildInputs = [ lv2 ];

  meta = with stdenv.lib; {
    homepage = "http://drobilla.net/software/lilv";
    description = "A C library to make the use of LV2 plugins";
    license = licenses.mit;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
