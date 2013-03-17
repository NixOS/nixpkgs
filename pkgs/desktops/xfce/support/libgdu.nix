{ stdenv, fetchurl, gnome, pkgconfig, glib, dbus_glib, intltool, udev, gtk
, libnotify, udisks, libatasmart, avahi
, autoconf, automake, libtool }:

let version = "2.30.1"; in

stdenv.mkDerivation rec {
  name = "libgdu-${version}";
  
  src = fetchurl {
    url = "mirror://gnome/sources/gnome-disk-utility/2.30/gnome-disk-utility-${version}.tar.bz2";
    sha256 = "df9b336c780b5d77ceda54e96f7c37c67645f5e73d48754ba0a8efba7c1836d7";
  };

  # Only build libgdu, not all that Gnome crap.
  patches = [ ./libgdu-only.patch ];

  buildInputs =
    [ pkgconfig glib dbus_glib udisks
      autoconf automake libtool
    ];

  preConfigure =
    ''
      substituteInPlace src/gdu/Makefile.am --replace /usr/share/dbus-1/interfaces ${udisks}/share/dbus-1/interfaces
      autoreconf -f -i
    '';

  postConfigure = "cd src/gdu";

  meta = {
    description = "Xfce/Gvfs support library for mounting filesystems";
  };
}
