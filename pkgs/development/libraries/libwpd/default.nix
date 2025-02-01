{ lib, stdenv, fetchurl, zlib, pkg-config, glib, libgsf, libxml2, librevenge, boost }:

stdenv.mkDerivation rec {
  pname = "libwpd";
  version = "0.10.3";

  src = fetchurl {
    url = "mirror://sourceforge/libwpd/libwpd-${version}.tar.xz";
    hash = "sha256-JGWwtmL9xdTjvrzcmnkCdxP7Ypyiv/BKPJJR/exC3Qk=";
  };

  patches = [ ./gcc-1.0.patch ];

  buildInputs = [ glib libgsf libxml2 zlib librevenge boost ];

  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "Library for importing and exporting WordPerfect documents";
    homepage = "https://libwpd.sourceforge.net/";
    license = licenses.lgpl21;
    platforms = platforms.unix;
  };
}
