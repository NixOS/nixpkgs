{ stdenv, fetchurl, pkgconfig, intltool, iconnamingutils, gtk }:

stdenv.mkDerivation rec {
  name = "gnome-icon-theme-3.6.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-icon-theme/3.6/${name}.tar.xz";
    sha256 = "0i8hkx2c1g5ckrvbkvs9n47i8fby8p9xs6p5l0mxdx9aq4smak9i";
  };

  nativeBuildInputs = [ pkgconfig intltool iconnamingutils gtk ];
}
