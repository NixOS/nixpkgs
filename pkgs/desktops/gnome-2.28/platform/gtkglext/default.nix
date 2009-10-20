{stdenv, fetchurl, pkgconfig, gtk, mesa}:

stdenv.mkDerivation {
  name = "gtkglext-1.0.6";
  src = fetchurl {
    url = mirror://gnome/sources/gtkglext/1.0/gtkglext-1.0.6.tar.bz2;
    sha256 = "1a9kpw1jx6d0dyljgv6f8kj2xdmyvrkyfds879wxk8x6n60gpcdj";
  };
  buildInputs = [ pkgconfig gtk mesa ];
}
