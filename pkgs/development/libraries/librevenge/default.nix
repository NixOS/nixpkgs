{stdenv, fetchurl, boost, pkgconfig, cppunit, zlib}:
let
  s = # Generated upstream information
  rec {
    baseName="librevenge";
    version="0.0.4";
    name="${baseName}-${version}";
    hash="1cj76cz4mqcy2mgv9l5xlc95bypyk8zbq0ls9cswqrs2y0lhfgwk";
    url="mirror://sourceforge/project/libwpd/librevenge/librevenge-0.0.4/librevenge-0.0.4.tar.xz";
    sha256="1cj76cz4mqcy2mgv9l5xlc95bypyk8zbq0ls9cswqrs2y0lhfgwk";
  };
  buildInputs = [
    boost pkgconfig cppunit zlib
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs;
  src = fetchurl {
    inherit (s) url sha256;
  };

  # Clang generates warnings in Boost's header files
  # -Werror causes these warnings to be interpreted as errors
  # Simplest solution: disable -Werror
  configureFlags = if stdenv.cc.isClang
    then [ "--disable-werror" ] else null;

  # Fix an issue with boost 1.59
  # This is fixed upstream so please remove this when updating
  postPatch = ''
    sed -i 's,-DLIBREVENGE_BUILD,\0 -DBOOST_ERROR_CODE_HEADER_ONLY,g' src/lib/Makefile.in
  '';

  meta = {
    inherit (s) version;
    description = ''A base library for writing document import filters'';
    license = stdenv.lib.licenses.mpl20 ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.unix;
  };
}
