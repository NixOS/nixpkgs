{ lib
, stdenv
, fetchurl
, pkg-config
, gettext
, itstool
, gtk3
, dbus-glib
, libnotify
, libxml2
, libcanberra-gtk3
, mod_dnssd
, apacheHttpd
, hicolor-icon-theme
, mate
, wrapGAppsHook
, mateUpdateScript
}:

stdenv.mkDerivation rec {
  pname = "mate-user-share";
  version = "1.26.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1wh0b4qw5wzpl7sg44lpwjb9r6xllch3xfz8c2cchl8rcgbh2kph";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    itstool
    libxml2
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    dbus-glib
    libnotify
    libcanberra-gtk3
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
    "--with-modules-path=${apacheHttpd}/modules"
    "--with-cajadir=$(out)/lib/caja/extensions-2.0"
  ];

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname version; };

  meta = with lib; {
    description = "User level public file sharing for the MATE desktop";
    homepage = "https://github.com/mate-desktop/mate-user-share";
    license = with licenses; [ gpl2Plus ];
    platforms = platforms.unix;
    maintainers = teams.mate.members;
  };
}
