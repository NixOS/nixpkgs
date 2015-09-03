{ stdenv, intltool, fetchurl, pkgconfig, udisks2, libsecret, libdvdread
, bash, gtk3, glib, makeWrapper, cracklib, libnotify
, itstool, gnome3, librsvg, gdk_pixbuf, libxml2, python
, libcanberra_gtk3, libxslt, libtool, docbook_xsl, libpwquality }:

stdenv.mkDerivation rec {
  name = "gnome-disk-utility-${gnome3.version}.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-disk-utility/${gnome3.version}/${name}.tar.xz";
    sha256 = "14h92bznizq0k4qz7hn41axhhfjyw2ncnmbkf8kldi9x909fvpml";
  };

  doCheck = true;

  NIX_CFLAGS_COMPILE = "-I${gnome3.glib}/include/gio-unix-2.0";

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  buildInputs = [ bash pkgconfig gtk3 glib intltool itstool
                  libxslt libtool libsecret libpwquality cracklib
                  libnotify libdvdread libcanberra_gtk3 docbook_xsl
                  gdk_pixbuf gnome3.defaultIconTheme
                  librsvg udisks2 gnome3.gnome_settings_daemon
                  gnome3.gsettings_desktop_schemas makeWrapper libxml2 ];

  preFixup = ''
    wrapProgram "$out/bin/gnome-disks" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix XDG_DATA_DIRS : "${gnome3.gnome_themes_standard}/share:$out/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    homepage = http://en.wikipedia.org/wiki/GNOME_Disks;
    description = "A udisks graphical front-end";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
