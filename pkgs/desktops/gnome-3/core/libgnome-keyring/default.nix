{ stdenv, fetchurl, glib, dbus_libs, libgcrypt, pkgconfig, intltool }:

stdenv.mkDerivation rec {
  name = "libgnome-keyring-3.6.0";

  src = fetchurl {
    url = "mirror://gnome/sources/libgnome-keyring/3.6/${name}.tar.xz";
    sha256 = "0c4qrjpmv1hqga3xv6wsq2z10x2n78qgw7q3k3s01y1pggxkgjkd";
  };

  propagatedBuildInputs = [ glib dbus_libs libgcrypt ];
  nativeBuildInputs = [ pkgconfig intltool ];

  meta = {
    inherit (glib.meta) platforms maintainers;
  };
}
