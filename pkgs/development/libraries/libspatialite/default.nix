{ stdenv, fetchurl, pkgconfig, libxml2, sqlite, zlib, proj, geos }:

stdenv.mkDerivation rec {
  name = "libspatialite-4.2.0";

  src = fetchurl {
    url = "http://www.gaia-gis.it/gaia-sins/${name}.tar.gz";
    sha256 = "0b9ipmp09y2ij7yajyjsh0zcwps8n5g88lzfzlkph33lail8l4wz";
  };

  buildInputs = [ pkgconfig libxml2 sqlite zlib proj geos ];

  configureFlags = "--disable-freexl";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Extensible spatial index library in C++";
    homepage = https://www.gaia-gis.it/fossil/libspatialite;
    # They allow any of these
    license = with licenses; [ gpl2Plus lgpl21Plus mpl11 ];
    platforms = platforms.linux;
  };
}
