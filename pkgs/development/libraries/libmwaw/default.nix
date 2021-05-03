{lib, stdenv, fetchurl, boost, pkg-config, cppunit, zlib, libwpg, libwpd, librevenge}:
let
  s = # Generated upstream information
  rec {
    baseName="libmwaw";
    version="0.3.18";
    name="${baseName}-${version}";
    hash="sha256-/F0FFoD4AAvmT/68CwxYcWscm/BgA+w5k4exCdHtHg8=";
    url="mirror://sourceforge/libmwaw/libmwaw/libmwaw-0.3.18/libmwaw-0.3.18.tar.xz";
    sha256="sha256-/F0FFoD4AAvmT/68CwxYcWscm/BgA+w5k4exCdHtHg8=";
  };

  nativeBuildInputs = [ pkg-config ];
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
    description = "Import library for some old mac text documents";
    license = lib.licenses.mpl20 ;
    maintainers = [lib.maintainers.raskin];
    platforms = lib.platforms.unix;
  };
}
