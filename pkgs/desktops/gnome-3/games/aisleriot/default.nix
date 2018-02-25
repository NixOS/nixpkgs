{ stdenv, fetchurl, pkgconfig, gnome3, intltool, itstool, gtk3
, wrapGAppsHook, gconf, librsvg, libxml2, desktop-file-utils
, guile_2_0, libcanberra-gtk3 }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  configureFlags = [ "--with-card-theme-formats=svg" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ intltool itstool gtk3 wrapGAppsHook gconf
                  librsvg libxml2 desktop-file-utils guile_2_0 libcanberra-gtk3 ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Aisleriot;
    description = "A collection of patience games written in guile scheme";
    maintainers = gnome3.maintainers;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
