{stdenv, fetchurl, cmake, qt4, perl, gettext, pango, gtk, dbus_glib, kdelibs, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kmplayer-0.11.1";
  src = fetchurl {
    url = http://kmplayer.kde.org/pkgs/kmplayer-0.11.1.tar.bz2;
    sha256 = "d10df9c31f540ab9442b75e0be0ed2cff9313de9004a4a8acbe3dbed79d5fddb";
  };
  builder = ./builder.sh;
  buildInputs = [ cmake qt4 perl gettext stdenv.gcc.libc pango gtk dbus_glib kdelibs automoc4 phonon ];
}
