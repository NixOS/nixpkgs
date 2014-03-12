{ stdenv, fetchurl, glib, dbus_libs, libgcrypt, pkgconfig, intltool, gobjectIntrospection }:

stdenv.mkDerivation rec {
  name = "libgnome-keyring-3.10.1";

  src = fetchurl {
    url = "mirror://gnome/sources/libgnome-keyring/3.10/${name}.tar.xz";
    sha256 = "0wip88r91kwx4zp6sc9b38mnlv11grgl4k2kzsd3a8x83c9g2b05";
  };

  propagatedBuildInputs = [ glib gobjectIntrospection dbus_libs libgcrypt ];
  nativeBuildInputs = [ pkgconfig intltool ];

  meta = {
    description = "Framework for managing passwords and other secrets";
    homepage = http://live.gnome.org/GnomeKeyring;
    # TODO license = with stdenv.lib.licenses; [ gpl2Plus lgpl2Plus ];
    inherit (glib.meta) platforms maintainers;

    longDescription = ''
      gnome-keyring is a program that keeps password and other secrets for
      users. The library libgnome-keyring is used by applications to integrate
      with the gnome-keyring system.
    '';
  };
}
