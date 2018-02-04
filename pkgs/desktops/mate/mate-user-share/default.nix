{ stdenv, fetchurl, pkgconfig, intltool, itstool, gtk3, dbus_glib, libnotify, libxml2, libcanberra_gtk3, caja, mod_dnssd, apacheHttpd, hicolor_icon_theme, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "mate-user-share-${version}";
  version = "${major-ver}.${minor-ver}";
  major-ver = "1.18";
  minor-ver = "0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${major-ver}/${name}.tar.xz";
    sha256 = "0w7r7jmm12n41hcxj1pfk3f0xy69cddx7ga490x191rdpcb3ry1n";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    itstool
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    dbus_glib
    libnotify
    libcanberra_gtk3
    libxml2
    caja
    hicolor_icon_theme
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
