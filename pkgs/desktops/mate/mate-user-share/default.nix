{ stdenv, fetchurl, pkgconfig, gettext, itstool, gtk3, dbus-glib, libnotify, libxml2, libcanberra-gtk3, mod_dnssd, apacheHttpd, hicolor-icon-theme, mate, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "mate-user-share";
  version = "1.24.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1h4aabcby96nsg557brzzb0an1qvnawhim2rinzlzg4fhkvdfnr5";
  };

  nativeBuildInputs = [
    pkgconfig
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
    "--with-modules-path=${apacheHttpd.dev}/modules"
    "--with-cajadir=$(out)/lib/caja/extensions-2.0"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "User level public file sharing for the MATE desktop";
    homepage = "https://github.com/mate-desktop/mate-user-share";
    license = with licenses; [ gpl2Plus ];
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
