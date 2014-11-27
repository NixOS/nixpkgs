{ stdenv, intltool, fetchurl, vala
, pkgconfig, gtk3, glib, hicolor_icon_theme
, makeWrapper, itstool, gnupg, libsoup
, gnome3, librsvg, gdk_pixbuf, gpgme
, libsecret, avahi, p11_kit }:

stdenv.mkDerivation rec {
  name = "seahorse-${gnome3.version}.0";

  src = fetchurl {
    url = "mirror://gnome/sources/seahorse/${gnome3.version}/${name}.tar.xz";
    sha256 = "2ea22830f5af1a11fadbdd8da6b34513410f2c371d9ec75fbf9b9b2d9177fc8a";
  };

  doCheck = true;

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  NIX_CFLAGS_COMPILE = "-I${gnome3.glib}/include/gio-unix-2.0";

  buildInputs = [ pkgconfig gtk3 glib intltool itstool gnome3.gcr
                  gnome3.gsettings_desktop_schemas makeWrapper gnupg
                  gdk_pixbuf gnome3.adwaita-icon-theme librsvg gpgme
                  libsecret avahi libsoup p11_kit vala gnome3.gcr
                  hicolor_icon_theme gnome3.adwaita-icon-theme ];

  preFixup = ''
    wrapProgram "$out/bin/seahorse" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix XDG_DATA_DIRS : "${gnome3.gnome_themes_standard}/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Seahorse;
    description = "Application for managing encryption keys and passwords in the GnomeKeyring";
    maintainers = with maintainers; [ lethalman ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
