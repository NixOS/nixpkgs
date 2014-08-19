{ stdenv, fetchurl, glib, dbus_libs, libgcrypt, pkgconfig, intltool, gobjectIntrospection }:

stdenv.mkDerivation rec {
  name = "libgnome-keyring-3.12.0";

  src = fetchurl {
    url = "mirror://gnome/sources/libgnome-keyring/3.12/${name}.tar.xz";
    sha256 = "c4c178fbb05f72acc484d22ddb0568f7532c409b0a13e06513ff54b91e947783";
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
