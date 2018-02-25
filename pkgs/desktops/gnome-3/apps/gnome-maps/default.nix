{ stdenv, fetchurl, intltool, pkgconfig, gnome3, gtk3
, gobjectIntrospection, gdk_pixbuf, librsvg, libgweather, autoreconfHook
, geoclue2, wrapGAppsHook, folks, libchamplain, gfbgraph, file, libsoup
, webkitgtk }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  doCheck = true;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ intltool gobjectIntrospection wrapGAppsHook
                  gtk3 geoclue2 gnome3.gjs gnome3.libgee folks gfbgraph
                  gnome3.geocode-glib libchamplain file libsoup
                  gdk_pixbuf librsvg libgweather autoreconfHook
                  gnome3.gsettings-desktop-schemas gnome3.evolution-data-server
                  gnome3.gnome-online-accounts gnome3.defaultIconTheme
                  webkitgtk ];

  # The .service file isn't wrapped with the correct environment
  # so misses GIR files when started. By re-pointing from the gjs
  # entry point to the wrapped binary we get back to a wrapped
  # binary.
  preConfigure = ''
    substituteInPlace "data/org.gnome.Maps.service.in" \
        --replace "Exec=@pkgdatadir@/org.gnome.Maps" \
                  "Exec=$out/bin/gnome-maps"
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Maps;
    description = "A map application for GNOME 3";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
