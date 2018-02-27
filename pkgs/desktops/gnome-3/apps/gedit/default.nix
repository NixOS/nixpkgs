{ stdenv, intltool, fetchurl, enchant, isocodes
, pkgconfig, gtk3, glib
, bash, wrapGAppsHook, itstool, libsoup, libxml2
, gnome3, librsvg, gdk_pixbuf, file, gspell }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  propagatedUserEnvPkgs = [ gnome3.gnome-themes-standard ];

  nativeBuildInputs = [ pkgconfig wrapGAppsHook ];

  buildInputs = [ gtk3 glib intltool itstool enchant isocodes
                  gdk_pixbuf gnome3.defaultIconTheme librsvg libsoup
                  gnome3.libpeas gnome3.gtksourceview libxml2
                  gnome3.gsettings-desktop-schemas gnome3.dconf file gspell ];

  enableParallelBuilding = true;

  preFixup = ''
    gappsWrapperArgs+=(--prefix LD_LIBRARY_PATH : "${stdenv.lib.makeLibraryPath [ gnome3.libpeas gnome3.gtksourceview ]}")
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Gedit;
    description = "Official text editor of the GNOME desktop environment";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
