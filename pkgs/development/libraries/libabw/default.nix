{ stdenv, fetchurl, boost, doxygen, gperf, pkgconfig, librevenge, libxml2, perl }:

stdenv.mkDerivation rec {
  name = "libabw-${version}";
  version = "0.1.2";

  src = fetchurl {
    url = "https://dev-www.libreoffice.org/src/libabw/${name}.tar.xz";
    sha256 = "11949iscdb99f2jplxjd39282jxcrf2fw0sqbh5dl7gqb96r8whb";
  };

  # Boost 1.59 compatability fix
  # Attempt removing when updating
  postPatch = ''
    sed -i 's,^CPPFLAGS.*,\0 -DBOOST_ERROR_CODE_HEADER_ONLY -DBOOST_SYSTEM_NO_DEPRECATED,' src/lib/Makefile.in
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ boost doxygen gperf librevenge libxml2 perl ];

  meta = with stdenv.lib; {
    homepage = https://wiki.documentfoundation.org/DLP/Libraries/libabw;
    description = "Library parsing abiword documents";
    platforms = platforms.unix;
    license = licenses.mpl20;
  };
}
