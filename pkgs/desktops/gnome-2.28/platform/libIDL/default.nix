{stdenv, fetchurl, flex, bison, pkgconfig, glib, gettext ? null}:

stdenv.mkDerivation {
  name = "libIDL-0.8.13";
  src = fetchurl {
    url = mirror://gnome/sources/libIDL/0.8/libIDL-0.8.13.tar.bz2;
    sha256 = "0w9b4q5sllwncz498sj5lmc3ajzc8x74dy0jy27m2yg9v887xk5w";
  };
  buildInputs = [ flex bison pkgconfig glib gettext ];
}
