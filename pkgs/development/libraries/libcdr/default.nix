{
  lib,
  stdenv,
  fetchurl,
  libwpg,
  libwpd,
  lcms,
  pkg-config,
  librevenge,
  icu,
  boost,
  cppunit,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "libcdr";
  version = "0.1.8";

  src = fetchurl {
    url = "https://dev-www.libreoffice.org/src/${pname}-${version}.tar.xz";
    hash = "sha256-ztZ3yDALKckdMAS7Hd3wuZdhv1VEmRwmwu6PQn6HGTw=";
  };

  strictDeps = true;

  buildInputs = [
    libwpg
    libwpd
    lcms
    librevenge
    icu
    boost
    cppunit
    zlib
  ];

  nativeBuildInputs = [ pkg-config ];

  enableParallelBuilding = true;

  meta = {
    description = "Library providing ability to interpret and import Corel Draw drawings into various applications";
    homepage = "https://wiki.documentfoundation.org/DLP/Libraries/libcdr";
    platforms = lib.platforms.all;
    license = lib.licenses.mpl20;
  };
}
