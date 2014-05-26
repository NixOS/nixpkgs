{ stdenv, intltool, fetchurl, pkgconfig, gtk3, glib, nspr, icu
, bash, makeWrapper, gnome3, libwnck3, libxml2, libxslt, libtool
, webkitgtk, libsoup, libsecret, gnome_desktop, libnotify, p11_kit
, sqlite, gcr, avahi, nss, isocodes, itstool, file, which
, hicolor_icon_theme, gdk_pixbuf, librsvg, gnome_common }:

stdenv.mkDerivation rec {
  name = "epiphany-3.12.1";

  src = fetchurl {
    url = "mirror://gnome/sources/epiphany/3.12/${name}.tar.xz";
    sha256 = "16d9f8f10443328b2f226c2da545e75c8433f50f103af8aeb692b098d5fbbf93";
  };

  # Tests need an X display
  configureFlags = [ "--disable-static --disable-tests" ];

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  nativeBuildInputs = [ pkgconfig file ];

  configureScript = "./autogen.sh";

  buildInputs = [ gtk3 glib intltool libwnck3 libxml2 libxslt pkgconfig file 
                  webkitgtk libsoup libsecret gnome_desktop libnotify libtool
                  sqlite isocodes nss itstool p11_kit nspr icu gnome3.yelp_tools
                  gdk_pixbuf gnome3.gnome_icon_theme librsvg which gnome_common
                  hicolor_icon_theme gnome3.gnome_icon_theme_symbolic
                  gcr avahi gnome3.gsettings_desktop_schemas makeWrapper ];

  NIX_CFLAGS_COMPILE = "-I${nspr}/include/nspr -I${nss}/include/nss -I${glib}/include/gio-unix-2.0";

  enableParallelBuilding = true;

  preFixup = ''
    for f in $out/bin/* $out/libexec/*; do
      wrapProgram "$f" \
        --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
        --prefix XDG_DATA_DIRS : "${gnome3.gnome_themes_standard}/share:$out/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
    done
  '';

  patches = [ ./libxml_missing_dep.patch ];
  patchFlags = "-p0";

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Epiphany;
    description = "WebKit based web browser for GNOME";
    maintainers = with maintainers; [ lethalman ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
