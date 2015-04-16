{ stdenv, fetchgit, pkgconfig
, automake, autoconf, libtool
, gtk_doc, intltool, glib
, dbus_glib
, which, file
, libexif
, menu-cache
, vala # optional
, gtk2
, pango
, cairo
}:

stdenv.mkDerivation rec {
  basename = "lxqt-libfm";
  version = "1.2.3";
  name = "${basename}-${version}";

  src = fetchgit {
    url = "https://github.com/lxde/libfm.git";
    rev = "f3442a330bb6aea5d9246e61da5911e75793db7f";
    sha256 = "349494252401766dd0ada85f148eaa9a021338da4e0e0b21a63458ed73ea2fd9";
  };

  buildInputs = [
    stdenv pkgconfig automake autoconf libtool gtk_doc intltool glib
    dbus_glib
    which file
    libexif menu-cache
    vala
    gtk2
    pango
    cairo
  ];

    #export PKG_CONFIG_PATH=${menu-cache}/lib/pkgconfig
  preConfigure = ''
    ./autogen.sh
  '';

  configureFlags = ''--without-gtk --disable-demo --enable-udisks'';

  meta = {
    homepage = "http://www.lxqt.org";
    description = "Library used to read freedesktop.org menus";
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.ellis ];
  };
}
