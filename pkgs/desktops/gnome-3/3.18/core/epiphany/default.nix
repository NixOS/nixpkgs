{ stdenv, intltool, fetchurl, pkgconfig, gtk3, glib, nspr, icu
, bash, makeWrapper, gnome3, libwnck3, libxml2, libxslt, libtool
, webkitgtk, libsoup, glib_networking, libsecret, gnome_desktop, libnotify, p11_kit
, sqlite, gcr, avahi, nss, isocodes, itstool, file, which
, gdk_pixbuf, librsvg, gnome_common }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  # Tests need an X display
  configureFlags = [ "--disable-static --disable-tests" ];

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  nativeBuildInputs = [ pkgconfig file ];

  buildInputs = [ gtk3 glib intltool libwnck3 libxml2 libxslt pkgconfig file 
                  webkitgtk libsoup libsecret gnome_desktop libnotify libtool
                  sqlite isocodes nss itstool p11_kit nspr icu gnome3.yelp_tools
                  gdk_pixbuf gnome3.defaultIconTheme librsvg which gnome_common
                  gcr avahi gnome3.gsettings_desktop_schemas makeWrapper ];

  NIX_CFLAGS_COMPILE = "-I${nspr.dev}/include/nspr -I${nss.dev}/include/nss -I${glib.dev}/include/gio-unix-2.0";

  enableParallelBuilding = true;

  preFixup = ''
    for f in $out/bin/* $out/libexec/*; do
      wrapProgram "$f" \
        --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
        --prefix GIO_EXTRA_MODULES : "${glib_networking}/lib/gio/modules" \
        --prefix XDG_DATA_DIRS : "${gnome3.gnome_themes_standard}/share:$out/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
    done
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Epiphany;
    description = "WebKit based web browser for GNOME";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
