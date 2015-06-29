{ stdenv, intltool, fetchurl, pkgconfig, gtk3, glib, nspr, icu
, bash, makeWrapper, gnome3, libwnck3, libxml2, libxslt, libtool
, webkitgtk, libsoup, libsecret, gnome_desktop, libnotify, p11_kit
, sqlite, gcr, avahi, nss, isocodes, itstool, file, which
, hicolor_icon_theme, gdk_pixbuf, librsvg, gnome_common }:

stdenv.mkDerivation rec {
  name = "epiphany-${gnome3.version}.0";

  src = fetchurl {
    url = "mirror://gnome/sources/epiphany/${gnome3.version}/${name}.tar.xz";
    sha256 = "1bicv1rfi697hk12p5n3jmcgjc81bwicjsmppdfjmvj94r4iniz8";
  };

  # Tests need an X display
  configureFlags = [ "--disable-static --disable-tests" ];

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  nativeBuildInputs = [ pkgconfig file ];

  configureScript = "./autogen.sh";

  buildInputs = [ gtk3 glib intltool libwnck3 libxml2 libxslt pkgconfig file 
                  webkitgtk libsoup libsecret gnome_desktop libnotify libtool
                  sqlite isocodes nss itstool p11_kit nspr icu gnome3.yelp_tools
                  gdk_pixbuf gnome3.adwaita-icon-theme librsvg which gnome_common
                  gcr avahi gnome3.gsettings_desktop_schemas makeWrapper ];

  NIX_CFLAGS_COMPILE = "-I${nspr}/include/nspr -I${nss}/include/nss -I${glib}/include/gio-unix-2.0";

  enableParallelBuilding = true;

  patches = [ ./libxml_depend.patch ];

  patchFlags = [ "-p0" ];

  preFixup = ''
    for f in $out/bin/* $out/libexec/*; do
      wrapProgram "$f" \
        --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
        --prefix XDG_DATA_DIRS : "${gnome3.gnome_themes_standard}/share:$out/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
    done
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Epiphany;
    description = "WebKit based web browser for GNOME";
    maintainers = with maintainers; [ lethalman ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
