{ stdenv, fetchurl, atk, glibmm, pkgconfig }:
let
  ver_maj = "2.24";
  ver_min = "2";
in
stdenv.mkDerivation rec {
  name = "atkmm-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://gnome/sources/atkmm/${ver_maj}/${name}.tar.xz";
    sha256 = "ff95385759e2af23828d4056356f25376cfabc41e690ac1df055371537e458bd";
  };

  propagatedBuildInputs = [ atk glibmm ];

  nativeBuildInputs = [ pkgconfig ];

  doCheck = true;

  meta = {
    description = "C++ wrappers for ATK accessibility toolkit";
    license = stdenv.lib.licenses.lgpl21Plus;
    homepage = http://gtkmm.org;
    platforms = stdenv.lib.platforms.unix;
  };
}
