{ stdenv, fetchurl, pkgconfig, glib, gtk, dbus_glib }:

stdenv.mkDerivation rec {
  name = "libunique-1.1.6";
  src = fetchurl {
    url = "mirror://gnome/sources/libunique/1.1/${name}.tar.bz2";
    sha256 = "1fsgvmncd9caw552lyfg8swmsd6bh4ijjsph69bwacwfxwf09j75";
  };

  # patches from Gentoo portage
  patches = [
    ./1.1.6-compiler-warnings.patch
    ./1.1.6-fix-test.patch
    ./1.1.6-G_CONST_RETURN.patch
    ./1.1.6-include-terminator.patch
  ];

  buildInputs = [ pkgconfig glib gtk dbus_glib ];

  # don't make deprecated usages hard errors
  preBuild = ''substituteInPlace unique/dbus/Makefile --replace -Werror ""'';

  doCheck = true;

  meta = {
    homepage = http://live.gnome.org/LibUnique;
    description = "A library for writing single instance applications";
    license = stdenv.lib.licenses.lgpl21;
  };
}
