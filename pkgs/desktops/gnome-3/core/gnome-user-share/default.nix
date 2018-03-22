{ stdenv, intltool, fetchurl, apacheHttpd, nautilus
, pkgconfig, gtk3, glib, libxml2, gnused, systemd
, bash, wrapGAppsHook, itstool, libnotify, libtool, mod_dnssd
, gnome3, librsvg, gdk_pixbuf, file, libcanberra-gtk3 }:

stdenv.mkDerivation rec {
  name = "gnome-user-share-${version}";
  version = "3.18.3";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-user-share/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "3092fa7ad137531e35484195dde4ecbbc75a8a3d9b8209aef4c852717cf4bbf1";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-user-share"; attrPath = "gnome3.gnome-user-share"; };
  };

  doCheck = true;

  NIX_CFLAGS_COMPILE = "-I${gnome3.glib.dev}/include/gio-unix-2.0";

  preConfigure = ''
    sed -e 's,^LoadModule dnssd_module.\+,LoadModule dnssd_module ${mod_dnssd}/modules/mod_dnssd.so,' \
      -e 's,''${HTTP_MODULES_PATH},${apacheHttpd}/modules,' \
      -i data/dav_user_2.4.conf
  '';

  configureFlags = [ "--with-httpd=${apacheHttpd.out}/bin/httpd"
                     "--with-modules-path=${apacheHttpd.dev}/modules"
                     "--with-systemduserunitdir=$(out)/etc/systemd/user"
                     "--with-nautilusdir=$(out)/lib/nautilus/extensions-3.0" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gtk3 glib intltool itstool libxml2 libtool
                  wrapGAppsHook file gdk_pixbuf gnome3.defaultIconTheme librsvg
                  nautilus libnotify libcanberra-gtk3 systemd ];

  postInstall = ''
    mkdir -p $out/share/gsettings-schemas/$name
    mv $out/share/glib-2.0 $out/share/gsettings-schemas/$name
    ${glib.dev}/bin/glib-compile-schemas $out/share/gsettings-schemas/$name/glib-2.0/schemas
  '';

  meta = with stdenv.lib; {
    homepage = https://help.gnome.org/users/gnome-user-share/3.8;
    description = "Service that exports the contents of the Public folder in your home directory on the local network";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
