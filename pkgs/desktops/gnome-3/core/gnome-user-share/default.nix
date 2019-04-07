{ stdenv
, gettext
, fetchurl
, apacheHttpd
, nautilus
, pkgconfig
, gtk3
, glib
, libxml2
, systemd
, wrapGAppsHook
, itstool
, libnotify
, mod_dnssd
, gnome3
, libcanberra-gtk3
}:

stdenv.mkDerivation rec {
  pname = "gnome-user-share";
  version = "3.32.0.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "16w6n0cjyzp8vln3zspvab8jhjprpvs88xc9x7bvigg0wry74945";
  };

  preConfigure = ''
    sed -e 's,^LoadModule dnssd_module.\+,LoadModule dnssd_module ${mod_dnssd}/modules/mod_dnssd.so,' \
      -e 's,''${HTTP_MODULES_PATH},${apacheHttpd}/modules,' \
      -i data/dav_user_2.4.conf
  '';

  configureFlags = [
    "--with-httpd=${apacheHttpd.out}/bin/httpd"
    "--with-modules-path=${apacheHttpd.dev}/modules"
    "--with-systemduserunitdir=${placeholder ''out''}/etc/systemd/user"
    "--with-nautilusdir=${placeholder ''out''}/lib/nautilus/extensions-3.0"
  ];

  nativeBuildInputs = [
    pkgconfig
    gettext
    itstool
    libxml2
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    glib
    nautilus
    libnotify
    libcanberra-gtk3
    systemd
  ];

  doCheck = true;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://help.gnome.org/users/gnome-user-share/3.8;
    description = "Service that exports the contents of the Public folder in your home directory on the local network";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
