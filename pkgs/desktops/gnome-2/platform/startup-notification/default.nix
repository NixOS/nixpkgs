{ stdenv, fetchurl, pkgconfig, xlibs }:

stdenv.mkDerivation {
  name = "startup-notification-0.9";
  src = fetchurl {
    url = mirror://gnome/sources/startup-notification/0.9/startup-notification-0.9.tar.bz2;
    sha256 = "03aqkgv8d29yx2vmv6bfdlxq3ahagrb7dbsvhd5d9acy6znimpk1";
  };
  buildInputs = [ pkgconfig xlibs.xlibs xlibs.xcbutil ];
}
