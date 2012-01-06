{ stdenv, fetchurl, glib, dbus_libs, libgcrypt, pkgconfig, xz,
intltool }:

stdenv.mkDerivation {
  name = "libgnome-keyring-3.2.2";

  src = fetchurl {
    url = mirror://gnome/sources/libgnome-keyring/3.2/libgnome-keyring-3.2.2.tar.xz;
    sha256 = "1cxd2vb1lzm8smq1q45dsn13s6kdqdb60lashdk7hwv035xy9jrb";
  };

  propagatedBuildInputs = [ glib dbus_libs libgcrypt ];
  buildNativeInputs = [ pkgconfig xz intltool ];
}
