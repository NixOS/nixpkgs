{ stdenv, intltool, fetchurl
, pkgconfig, gtk3, glib
, bash, wrapGAppsHook, itstool
, gnome3, librsvg, gdk_pixbuf }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  doCheck = true;

  NIX_CFLAGS_COMPILE = "-I${gnome3.glib.dev}/include/gio-unix-2.0";

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  buildInputs = [ pkgconfig gtk3 glib intltool itstool gnome3.gnome_desktop
                  gdk_pixbuf gnome3.defaultIconTheme librsvg
                  gnome3.gsettings_desktop_schemas wrapGAppsHook ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${gnome3.gnome_themes_standard}/share"
    )
  '';

  meta = with stdenv.lib; {
    description = "Program that can preview fonts and create thumbnails for fonts";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
