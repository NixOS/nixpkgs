{ stdenv, fetchurl, pkgconfig, glib, gtk3, libgee, intltool }:

let
  major = "1";
  minor = "0";
in stdenv.mkDerivation rec {
  version = "${major}.${minor}";
  name = "libgames-support-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/libgames-support/${version}/${name}.tar.xz";
    sha256 = "02qn009m1i07nh8wnyrrjf7kbbapk814ap5pvin5ka5sj996cyqq";
  };

  buildInputs = [ pkgconfig glib gtk3 libgee intltool ];

  meta = with stdenv.lib; {
    description = "Small library intended for internal use by GNOME Games, but it may be used by others";
    homepage = https://github.com/GNOME/libgames-support;
    license = licenses.gpl3;
  };
}
