{ stdenv, fetchurl, pkgconfig, intltool, gnupg, p11_kit, glib
, libgcrypt, libtasn1, dbus_glib, gtk, pango, gdk_pixbuf, atk }:

stdenv.mkDerivation rec {
  name = "gcr-3.6.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gcr/3.6/${name}.tar.xz";
    sha256 = "16xyqxv2hxl3a4m8ahilqcf1ps58w1ijh8dav1l5nqz36ljdn2gp";
  };

  buildInputs = [
    pkgconfig intltool gnupg p11_kit glib
    libgcrypt libtasn1 dbus_glib gtk pango gdk_pixbuf atk
  ];

  #doCheck = true;
}
