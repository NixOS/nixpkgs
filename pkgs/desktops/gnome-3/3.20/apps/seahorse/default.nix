{ stdenv, intltool, fetchurl, vala_0_32
, pkgconfig, gtk3, glib
, makeWrapper, itstool, gnupg, libsoup
, gnome3, librsvg, gdk_pixbuf, gpgme
, libsecret, avahi, p11_kit, openssh }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  doCheck = true;

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  NIX_CFLAGS_COMPILE = "-I${gnome3.glib.dev}/include/gio-unix-2.0";

  buildInputs = [ pkgconfig gtk3 glib intltool itstool gnome3.gcr
                  gnome3.gsettings_desktop_schemas makeWrapper gnupg
                  gdk_pixbuf gnome3.defaultIconTheme librsvg gpgme
                  libsecret avahi libsoup p11_kit vala_0_32 gnome3.gcr
                  openssh ];

  preFixup = ''
    wrapProgram "$out/bin/seahorse" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix XDG_DATA_DIRS : "${gnome3.gnome_themes_standard}/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Seahorse;
    description = "Application for managing encryption keys and passwords in the GnomeKeyring";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
