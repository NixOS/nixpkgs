{ stdenv, fetchurl, pkgconfig, intltool, itstool, gtk3, libnotify, libxml2, libcanberra-gtk3, mod_dnssd, apacheHttpd, hicolor-icon-theme, mate, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "mate-user-share-${version}";
  version = "1.22.0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "14bhr6fv6gj3ka3sf13q64ck4svx8f4x8kzbppxv0jygpjp48w7h";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    itstool
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
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
