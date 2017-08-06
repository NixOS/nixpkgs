{ stdenv, intltool, fetchurl, pkgconfig, libcanberra_gtk3
, bash, gtk3, glib, wrapGAppsHook
, itstool, gnome3, librsvg, gdk_pixbuf }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  doCheck = true;

  NIX_CFLAGS_COMPILE = "-I${gnome3.glib.dev}/include/gio-unix-2.0";

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];
  propagatedBuildInputs = [ gdk_pixbuf gnome3.defaultIconTheme librsvg ];

  buildInputs = [ bash pkgconfig gtk3 glib intltool itstool libcanberra_gtk3
                  gnome3.gsettings_desktop_schemas wrapGAppsHook ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${gtk3.out}/share:${gnome3.gnome_themes_standard}/share"
    )
  '';

  meta = with stdenv.lib; {
    homepage = http://en.wikipedia.org/wiki/GNOME_Screenshot;
    description = "Utility used in the GNOME desktop environment for taking screenshots";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
