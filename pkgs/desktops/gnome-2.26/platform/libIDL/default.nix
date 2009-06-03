{stdenv, fetchurl, flex, bison, pkgconfig, glib}:

stdenv.mkDerivation {
  name = "libIDL-0.8.13";
  src = fetchurl {
    url = mirror://gnome/platform/2.26/2.26.2/sources/libIDL-0.8.13.tar.bz2;
    sha256 = "bccc7e10dae979518ff012f8464e47ec4b3558a5456a94c8679653aa0b262b71";
  };
  buildInputs = [ flex bison pkgconfig glib ];
}
