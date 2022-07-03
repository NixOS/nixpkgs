{ lib, stdenv, fetchurl, pkg-config, gtk2, intltool,
GConf, enchant, isocodes, gnome-icon-theme }:

stdenv.mkDerivation rec {
  pname = "gtkhtml";
  version = "3.32.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gtkhtml/${lib.versions.majorMinor version}/gtkhtml-${version}.tar.bz2";
    sha256 = "17z3jwvpn8waz7bhwrk7a6vs9pad6sqmlxxcqwvxxq89ywy0ail7";
  };

  #From Debian, fixes build issue described here:
  #http://www.mail-archive.com/debian-bugs-rc@lists.debian.org/msg250091.html
  patches = [ ./01_remove-disable-deprecated.patch ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gtk2 intltool GConf enchant isocodes gnome-icon-theme ];

  NIX_LDFLAGS = "-lgthread-2.0";
}
