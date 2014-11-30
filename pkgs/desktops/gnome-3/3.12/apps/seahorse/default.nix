{ stdenv, intltool, fetchurl, vala
, pkgconfig, gtk3, glib, hicolor_icon_theme
, makeWrapper, itstool, gnupg, libsoup
, gnome3, librsvg, gdk_pixbuf, gpgme
, libsecret, avahi, p11_kit }:

stdenv.mkDerivation rec {
  name = "seahorse-3.12.2";

  src = fetchurl {
    url = "mirror://gnome/sources/seahorse/3.12/${name}.tar.xz";
    sha256 = "5e6fb25373fd4490e181e2fa0f5cacf99b78b2f6caa5d91c9c605900fb5f3839";
  };

  doCheck = true;

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  NIX_CFLAGS_COMPILE = "-I${gnome3.glib}/include/gio-unix-2.0";

  buildInputs = [ pkgconfig gtk3 glib intltool itstool gnome3.gcr
                  gnome3.gsettings_desktop_schemas makeWrapper gnupg
                  gdk_pixbuf gnome3.gnome_icon_theme librsvg gpgme
                  libsecret avahi libsoup p11_kit vala gnome3.gcr
                  hicolor_icon_theme gnome3.gnome_icon_theme_symbolic ];

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
