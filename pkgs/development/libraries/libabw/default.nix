{ lib, stdenv, fetchurl, boost, doxygen, gperf, pkg-config, librevenge, libxml2, perl }:

stdenv.mkDerivation rec {
  pname = "libabw";
  version = "0.1.3";

  src = fetchurl {
    url = "https://dev-www.libreoffice.org/src/libabw/${pname}-${version}.tar.xz";
    sha256 = "1vbfrmnvib3cym0yyyabnd8xpx4f7wp20vnn09s6dln347fajqz7";
  };

  # Boost 1.59 compatibility fix
  # Attempt removing when updating
  postPatch = ''
    sed -i 's,^CPPFLAGS.*,\0 -DBOOST_ERROR_CODE_HEADER_ONLY -DBOOST_SYSTEM_NO_DEPRECATED,' src/lib/Makefile.in
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ boost doxygen gperf librevenge libxml2 perl ];

  meta = with lib; {
    homepage = "https://wiki.documentfoundation.org/DLP/Libraries/libabw";
    description = "Library parsing abiword documents";
    platforms = platforms.unix;
    license = licenses.mpl20;
  };
}
