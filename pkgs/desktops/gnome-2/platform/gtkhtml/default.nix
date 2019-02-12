{ stdenv, fetchurl, pkgconfig, gtk, intltool,
GConf, enchant, isocodes, gnome_icon_theme }:

stdenv.mkDerivation rec {
  name = "gtkhtml-3.32.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gtkhtml/3.32/${name}.tar.bz2";
    sha256 = "17z3jwvpn8waz7bhwrk7a6vs9pad6sqmlxxcqwvxxq89ywy0ail7";
  };

  #From Debian, fixes build issue described here:
  #http://www.mail-archive.com/debian-bugs-rc@lists.debian.org/msg250091.html
  patches = [ ./01_remove-disable-deprecated.patch ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gtk intltool GConf enchant isocodes gnome_icon_theme ];

  NIX_LDFLAGS = [ "-lgthread-2.0" ];
}
