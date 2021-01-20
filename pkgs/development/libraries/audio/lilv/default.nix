{ stdenv, fetchurl, lv2, pkg-config, python3, serd, sord, sratom, wafHook }:

stdenv.mkDerivation rec {
  pname = "lilv";
  version = "0.24.10";

  src = fetchurl {
    url = "https://download.drobilla.net/${pname}-${version}.tar.bz2";
    sha256 = "1565zy0yz46cf2f25pi46msdnzkj6bbhml9gfigdpjnsdlyskfyi";
  };

  patches = [ ./lilv-pkgconfig.patch ];

  nativeBuildInputs = [ pkg-config python3 wafHook ];
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
