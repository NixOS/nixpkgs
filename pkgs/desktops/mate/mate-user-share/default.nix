{ stdenv, fetchurl, pkgconfig, intltool, itstool, gtk3, dbus-glib, libnotify, libxml2, libcanberra-gtk3, mod_dnssd, apacheHttpd, hicolor-icon-theme, mate, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "mate-user-share-${version}";
  version = "1.20.0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "0lv5ndjk2br4w7cw8gsgj7aa2iadxv7m4wii4c49pajmd950iff2";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    itstool
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    dbus-glib
    libnotify
    libcanberra-gtk3
    libxml2
    mate.caja
    hicolor-icon-theme
    # Should mod_dnssd and apacheHttpd be runtime dependencies?
    # In gnome-user-share they are not.
    #mod_dnssd
    #apacheHttpd
  ];

  preConfigure = ''
    sed -e 's,^LoadModule dnssd_module.\+,LoadModule dnssd_module ${mod_dnssd}/modules/mod_dnssd.so,' \
      -e 's,''${HTTP_MODULES_PATH},${apacheHttpd}/modules,' \
      -i data/dav_user_2.4.conf
  '';

  configureFlags = [
    "--with-httpd=${apacheHttpd.out}/bin/httpd"
    "--with-modules-path=${apacheHttpd.dev}/modules"
    "--with-cajadir=$(out)/lib/caja/extensions-2.0"
  ];

  meta = with stdenv.lib; {
    description = "User level public file sharing for the MATE desktop";
    homepage = https://github.com/mate-desktop/mate-user-share;
    license = with licenses; [ gpl2Plus ];
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
