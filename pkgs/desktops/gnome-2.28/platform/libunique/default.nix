{stdenv, fetchurl, pkgconfig, gettext, gtk}:

stdenv.mkDerivation {
  name = "libunique-1.1.2";
  src = fetchurl {
    url = mirror:/gnome/sources/libunique/1.1/libunique-1.1.2.tar.bz2;
    sha256 = "0vhcbw4ccc58xhs99r6bkabrzbayyq2qk01xm8vv4hpwjl117yvk"
  };
  buildInputs = [ pkgconfig gettext gtk ];
}
