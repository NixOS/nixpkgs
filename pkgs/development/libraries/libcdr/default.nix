{ stdenv, fetchurl, libwpg, libwpd, lcms, pkgconfig, librevenge, icu, boost }:

stdenv.mkDerivation rec {
  name = "libcdr-0.1.1";

  src = fetchurl {
    url = "http://dev-www.libreoffice.org/src/${name}.tar.bz2";
    sha256 = "0javd72wmaqd6vprsh3clm393b3idjdjzbb7vyn44li7yaxppzkj";
  };

  buildInputs = [ libwpg libwpd lcms librevenge icu boost ];

  nativeBuildInputs = [ pkgconfig ];

  # Boost 1.59 compatability fix
  # Attempt removing when updating
  postPatch = ''
    sed -i 's,^CPPFLAGS.*,\0 -DBOOST_ERROR_CODE_HEADER_ONLY -DBOOST_SYSTEM_NO_DEPRECATED,' src/lib/Makefile.in
  '';

  configureFlags = if stdenv.cc.isClang
    then [ "--disable-werror" ] else null;

  CXXFLAGS="--std=gnu++0x"; # For c++11 constants in lcms2.h

  meta = {
    description = "A library providing ability to interpret and import Corel Draw drawings into various applications";
    homepage = http://www.freedesktop.org/wiki/Software/libcdr;
    platforms = stdenv.lib.platforms.all;
  };
}
