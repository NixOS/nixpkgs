{ stdenv, intltool, fetchurl, evolution_data_server, db
, pkgconfig, gtk3, glib, hicolor_icon_theme, libsecret
, bash, makeWrapper, itstool, folks, libnotify, libxml2
, gnome3, librsvg, gdk_pixbuf, file, telepathy_glib, nspr, nss
, libsoup, vala, dbus_glib, automake114x, autoconf }:

stdenv.mkDerivation rec {
  name = "gnome-contacts-3.10.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-contacts/3.10/${name}.tar.xz";
    sha256 = "e119c32bb10136e7190f11f79334fa82ed56468cff5bb7836da0ebf7b572779b";
  };

  doCheck = true;

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard evolution_data_server ];
  propagatedBuildInputs = [ gdk_pixbuf gnome3.gnome_icon_theme librsvg
                            hicolor_icon_theme gnome3.gnome_icon_theme_symbolic ];

  # force build from vala
  preBuild = ''
   touch src/*.vala
  '';

  buildInputs = [ pkgconfig gtk3 glib intltool itstool evolution_data_server
                  gnome3.gsettings_desktop_schemas makeWrapper file libnotify
                  folks gnome3.gnome_desktop telepathy_glib libsecret dbus_glib
                  libxml2 libsoup gnome3.gnome_online_accounts nspr nss
                  vala automake114x autoconf db ];

  preFixup = ''
    for f in "$out/bin/gnome-contacts" "$out/libexec/gnome-contacts-search-provider"; do
      wrapProgram $f \
        --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
        --prefix XDG_DATA_DIRS : "${gtk3}/share:${gnome3.gnome_themes_standard}/share:$out/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
    done
  '';

  patches = [ ./configure_dbus_glib.patch ./fix_row_selected.patch ];

  patchFlags = "-p0";

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Contacts;
    description = "Contacts is GNOME's integrated address book";
    maintainers = with maintainers; [ lethalman ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
