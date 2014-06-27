{stdenv, fetchurl, boost, pkgconfig, cppunit, zlib}:
let
  s = # Generated upstream information
  rec {
    baseName="librevenge";
    version="0.0.1";
    name="${baseName}-${version}";
    hash="0zgfxvbqf11pypyc0vmcan73x197f7ia1ywin9qqy9hvvmrjgchc";
    url="mirror://sourceforge/project/libwpd/librevenge/librevenge-0.0.1/librevenge-0.0.1.tar.xz";
    sha256="0zgfxvbqf11pypyc0vmcan73x197f7ia1ywin9qqy9hvvmrjgchc";
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
  meta = {
    inherit (s) version;
    description = ''A base library for writing document import filters'';
    license = stdenv.lib.licenses.mpl20 ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
