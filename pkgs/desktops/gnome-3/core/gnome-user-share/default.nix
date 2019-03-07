{ stdenv, intltool, fetchurl, apacheHttpd, nautilus
, pkgconfig, gtk3, glib, libxml2, systemd, adwaita-icon-theme
, wrapGAppsHook, itstool, libnotify, libtool, mod_dnssd
, gnome3, librsvg, gdk_pixbuf, file, libcanberra-gtk3 }:

stdenv.mkDerivation rec {
  name = "gnome-user-share-${version}";
  version = "3.32.0.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-user-share/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "16w6n0cjyzp8vln3zspvab8jhjprpvs88xc9x7bvigg0wry74945";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-user-share"; attrPath = "gnome3.gnome-user-share"; };
  };

  doCheck = true;

  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  preConfigure = ''
    sed -e 's,^LoadModule dnssd_module.\+,LoadModule dnssd_module ${mod_dnssd}/modules/mod_dnssd.so,' \
      -e 's,''${HTTP_MODULES_PATH},${apacheHttpd}/modules,' \
      -i data/dav_user_2.4.conf
  '';

  configureFlags = [
    "--with-httpd=${apacheHttpd.out}/bin/httpd"
    "--with-modules-path=${apacheHttpd.dev}/modules"
    "--with-systemduserunitdir=$(out)/etc/systemd/user"
    "--with-nautilusdir=$(out)/lib/nautilus/extensions-3.0"
  ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    gtk3 glib intltool itstool libxml2 libtool
    wrapGAppsHook file gdk_pixbuf adwaita-icon-theme librsvg
    nautilus libnotify libcanberra-gtk3 systemd
  ];

  postInstall = ''
    glib-compile-schemas "$out/share/gsettings-schemas/$name/glib-2.0/schemas"
  '';

  meta = with stdenv.lib; {
    homepage = https://help.gnome.org/users/gnome-user-share/3.8;
    description = "Service that exports the contents of the Public folder in your home directory on the local network";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
