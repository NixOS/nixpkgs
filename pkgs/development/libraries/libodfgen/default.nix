{stdenv, fetchurl, boost, pkgconfig, cppunit, zlib, libwpg, libwpd, librevenge}:
let
  s = # Generated upstream information
  rec {
    baseName="libodfgen";
    version="0.1.7";
    name="${baseName}-${version}";
    hash="0cdq48wlpp8m0qmndybv64r0m4vh0qsqx69cn6ms533cjlgljgij";
    url="mirror://sourceforge/project/libwpd/libodfgen/libodfgen-0.1.7/libodfgen-0.1.7.tar.xz";
    sha256="0cdq48wlpp8m0qmndybv64r0m4vh0qsqx69cn6ms533cjlgljgij";
  };
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    boost cppunit zlib libwpg libwpd librevenge
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit nativeBuildInputs buildInputs;
  src = fetchurl {
    inherit (s) url sha256;
  };
  meta = {
    inherit (s) version;
    description = ''A base library for generating ODF documents'';
    license = stdenv.lib.licenses.mpl20 ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.unix;
  };
}
