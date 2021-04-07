{lib, stdenv, fetchurl, boost, pkg-config, cppunit, zlib, libwpg, libwpd, librevenge}:
let
  s = # Generated upstream information
  rec {
    baseName="libmwaw";
    version="0.3.17";
    name="${baseName}-${version}";
    hash="074ipcq9w7jbd5x316dzclddgia2ydw098ph9d7p3d713pmkf5cf";
    url="mirror://sourceforge/libmwaw/libmwaw/libmwaw-0.3.17/libmwaw-0.3.17.tar.xz";
    sha256="074ipcq9w7jbd5x316dzclddgia2ydw098ph9d7p3d713pmkf5cf";
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
