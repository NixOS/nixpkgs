{ lib, stdenv, fetchurl, boost, pkg-config, cppunit, zlib }:

stdenv.mkDerivation rec {
  pname = "librevenge";
  version = "0.0.5";

  src = fetchurl {
    url = "mirror://sourceforge/project/libwpd/librevenge/librevenge-${version}/librevenge-${version}.tar.xz";
    sha256 = "sha256-EG0MRLtkCLE0i54EZWZvqDuBYXdmWiLNAX6IbBqu6zQ=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    boost
    cppunit
    zlib
  ];

  # Clang and gcc-7 generate warnings, and
  # -Werror causes these warnings to be interpreted as errors
  # Simplest solution: disable -Werror
  configureFlags = [ "--disable-werror" ];

  # Fix an issue with boost 1.59
  # This is fixed upstream so please remove this when updating
  postPatch = ''
    sed -i 's,-DLIBREVENGE_BUILD,\0 -DBOOST_ERROR_CODE_HEADER_ONLY,g' src/lib/Makefile.in
  '';

  meta = with lib; {
    description = "A base library for writing document import filters";
    license = licenses.mpl20;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.unix;
  };
}
