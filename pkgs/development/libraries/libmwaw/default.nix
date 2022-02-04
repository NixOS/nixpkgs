{ lib, stdenv, fetchurl, boost, pkg-config, cppunit, zlib, libwpg, libwpd, librevenge }:

stdenv.mkDerivation rec {
  pname = "libmwaw";
  version = "0.3.21";

  src = fetchurl {
    url = "mirror://sourceforge/libmwaw/libmwaw/libmwaw-${version}/libmwaw-${version}.tar.xz";
    sha256 = "sha256-6HUBI6eNYblDzveLdzbIp/ILsKZJqhEkAhJPunlPwhw=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    boost
    cppunit
    zlib
    libwpg
    libwpd
    librevenge
  ];
  enableParallelBuilding = true;

  meta = with lib; {
    description = "Import library for some old mac text documents";
    license = licenses.mpl20;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.unix;
  };
}
