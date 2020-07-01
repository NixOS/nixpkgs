{ stdenv, fetchurl, gperf, pkgconfig, librevenge, libxml2, boost, icu
, cppunit, zlib, liblangtag
}:

let
  s = # Generated upstream information
  rec {
    baseName="libe-book";
    version="0.1.3";
    name="${baseName}-${version}";
    hash="1yg1vws1wggzhjw672bpgh2x541g5i9wryf67g51m0r79zrqz3by";
    url="https://kent.dl.sourceforge.net/project/libebook/libe-book-0.1.3/libe-book-0.1.3.tar.xz";
    sha256="1yg1vws1wggzhjw672bpgh2x541g5i9wryf67g51m0r79zrqz3by";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    gperf librevenge libxml2 boost icu cppunit zlib liblangtag
  ];

  # Boost 1.59 compatability fix
  # Attempt removing when updating
  postPatch = ''
    sed -i 's,^CPPFLAGS.*,\0 -DBOOST_ERROR_CODE_HEADER_ONLY -DBOOST_SYSTEM_NO_DEPRECATED,' src/lib/Makefile.in
  '';
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit nativeBuildInputs buildInputs postPatch;
  src = fetchurl {
    inherit (s) url sha256;
  };
  NIX_CFLAGS_COMPILE = "-Wno-error=unused-function";
  meta = {
    inherit (s) version;
    description = ''Library for import of reflowable e-book formats'';
    license = stdenv.lib.licenses.lgpl21Plus ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.unix;
  };
}
