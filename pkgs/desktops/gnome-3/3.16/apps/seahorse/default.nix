{ stdenv, intltool, fetchurl, vala
, pkgconfig, gtk3, glib
, makeWrapper, itstool, gnupg, libsoup
, gnome3, librsvg, gdk_pixbuf, gpgme
, libsecret, avahi, p11_kit, openssh }:

let
  majVer = gnome3.version;
in stdenv.mkDerivation rec {
  name = "seahorse-${majVer}.0";

  src = fetchurl {
    url = "mirror://gnome/sources/seahorse/${majVer}/${name}.tar.xz";
    sha256 = "0cg1grgpwbfkiny5148n17rzpc8kswyr5yff0kpm8l3lp01my2kp";
  };

  doCheck = true;

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  NIX_CFLAGS_COMPILE = "-I${gnome3.glib}/include/gio-unix-2.0";

  buildInputs = [ pkgconfig gtk3 glib intltool itstool gnome3.gcr
                  gnome3.gsettings_desktop_schemas makeWrapper gnupg
                  gdk_pixbuf gnome3.defaultIconTheme librsvg gpgme
                  libsecret avahi libsoup p11_kit vala gnome3.gcr
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
