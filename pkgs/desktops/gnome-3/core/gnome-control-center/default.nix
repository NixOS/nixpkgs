{ fetchurl, stdenv, pkgconfig, gnome3, ibus, intltool, upower, makeWrapper
, libcanberra, accountservice, libpwquality, pulseaudio, fontconfig
, gdk_pixbuf, hicolor_icon_theme, librsvg, libxkbfile, libnotify
, libxml2, polkit, libxslt, libgtop, libsoup, colord, colord-gtk
, cracklib, python, krb5, networkmanagerapplet, networkmanager
, libwacom, samba, shared_mime_info, tzdata, icu, libtool
, docbook_xsl, docbook_xsl_ns, modemmanager }:

# http://ftp.gnome.org/pub/GNOME/teams/releng/3.10.2/gnome-suites-core-3.10.2.modules
# TODO: bluetooth, wacom, smbclient, printers

stdenv.mkDerivation rec {
  name = "gnome-control-center-3.10.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-control-center/3.10/${name}.tar.xz";
    sha256 = "1ac34kqkf174w0qc12p927dfhcm69xnv7fqzmbhjab56rn49wypn";
  };

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard gnome3.libgnomekbd ];
  propagatedBuildInputs = [ gdk_pixbuf gnome3.gnome_icon_theme librsvg
                            hicolor_icon_theme gnome3.gnome_icon_theme_symbolic ];

  enableParallelBuilding = true;

  buildInputs = with gnome3;
    [ pkgconfig intltool ibus gtk glib upower libcanberra gsettings_desktop_schemas
      libxml2 gnome_desktop gnome_settings_daemon polkit libxslt libgtop gnome-menus
      gnome_online_accounts libsoup colord pulseaudio fontconfig colord-gtk libpwquality
      accountservice krb5 networkmanagerapplet libwacom samba libnotify libxkbfile
      shared_mime_info icu libtool docbook_xsl docbook_xsl_ns 
      networkmanager modemmanager makeWrapper  ];

  preBuild = ''
    substituteInPlace tz.h --replace "/usr/share/zoneinfo/zone.tab" "${tzdata}/share/zoneinfo/zone.tab"
    substituteInPlace panels/datetime/tz.h --replace "/usr/share/zoneinfo/zone.tab" "${tzdata}/share/zoneinfo/zone.tab"

    # hack to make test-endianess happy
    mkdir -p $out/share/locale
    substituteInPlace panels/datetime/test-endianess.c --replace "/usr/share/locale/" "$out/share/locale/"
  '';

  preFixup = with gnome3; ''
    wrapProgram $out/bin/gnome-control-center \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix XDG_DATA_DIRS : "${gnome3.gnome_themes_standard}/share:${gnome_settings_daemon}/share:${glib}/share:${gtk}/share:${colord}/share:$out/share:$out/share/gnome-control-center:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
    for i in $out/share/applications/*; do
      substituteInPlace $i --replace "gnome-control-center" "$out/bin/gnome-control-center"
    done

    rm $out/share/icons/hicolor/icon-theme.cache
  '';

  patches = [ ./search_providers_dir.patch ];

  meta = with stdenv.lib; {
    description = "Single sign-on framework for GNOME";
    maintainers = with maintainers; [ lethalman ];
    platforms = platforms.linux;
  };

}
