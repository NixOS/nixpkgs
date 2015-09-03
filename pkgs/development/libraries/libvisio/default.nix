{ stdenv, fetchurl, boost, libwpd, libwpg, pkgconfig, zlib, gperf
, librevenge, libxml2, icu, perl
}:

stdenv.mkDerivation rec {
  name = "libvisio-0.1.3";

  src = fetchurl {
    url = "http://dev-www.libreoffice.org/src/${name}.tar.bz2";
    sha256 = "1blgdwxprqkasm2175imcvy647sqv6xyf3k09p0b1i7hlq889wvy";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ boost libwpd libwpg zlib gperf librevenge libxml2 icu perl ];

  # Boost 1.59 compatability fix
  # Attempt removing when updating
  postPatch = ''
    sed -i 's,^CPPFLAGS.*,\0 -DBOOST_ERROR_CODE_HEADER_ONLY -DBOOST_SYSTEM_NO_DEPRECATED,' src/lib/Makefile.in
  '';

  configureFlags = [
    "--disable-werror"
    "--disable-tests"
  ];

  meta = {
    description = "A library providing ability to interpret and import visio diagrams into various applications";
    homepage = http://www.freedesktop.org/wiki/Software/libvisio;
    platforms = stdenv.lib.platforms.unix;
  };
}
