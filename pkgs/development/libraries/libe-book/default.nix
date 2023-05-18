{ lib
, stdenv
, fetchurl
, gperf
, pkg-config
, librevenge
, libxml2
, boost
, icu
, cppunit
, zlib
, liblangtag
}:

stdenv.mkDerivation rec {
  pname = "libe-book";
  version = "0.1.3";
  src = fetchurl {
    url = "https://kent.dl.sourceforge.net/project/libebook/libe-book-${version}/libe-book-${version}.tar.xz";
    sha256 = "sha256-fo2P808ngxrKO8b5zFMsL5DSBXx3iWO4hP89HjTf4fk=";
  };
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    gperf
    librevenge
    libxml2
    boost
    icu
    cppunit
    zlib
    liblangtag
  ];
  # Boost 1.59 compatability fix
  # Attempt removing when updating
  postPatch = ''
    sed -i 's,^CPPFLAGS.*,\0 -DBOOST_ERROR_CODE_HEADER_ONLY -DBOOST_SYSTEM_NO_DEPRECATED,' src/lib/Makefile.in
  '';
  env.NIX_CFLAGS_COMPILE = "-Wno-error=unused-function";
  meta = with lib; {
    description = "Library for import of reflowable e-book formats";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.unix;
  };
}
