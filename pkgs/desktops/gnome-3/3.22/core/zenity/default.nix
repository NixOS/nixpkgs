{ stdenv, fetchurl, pkgconfig, cairo, libxml2, libxslt, gnome3, pango
, gnome_doc_utils, intltool, libX11, which, itstool, wrapGAppsHook }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  preBuild = ''
    mkdir -p $out/include
  '';

  buildInputs = [ gnome3.gtk libxml2 libxslt libX11 itstool ];

  nativeBuildInputs = [ pkgconfig intltool gnome_doc_utils which wrapGAppsHook ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
