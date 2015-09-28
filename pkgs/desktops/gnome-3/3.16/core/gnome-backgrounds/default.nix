{ stdenv, fetchurl, pkgconfig, gnome3, intltool }:

stdenv.mkDerivation rec {
  name = "gnome-backgrounds-${gnome3.version}.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-backgrounds/${gnome3.version}/${name}.tar.xz";
    sha256 = "0fx0pjz356v4w462i9a3z9r26khxqmj0zhp7wfl5scyq07fzkqvn";
  };

  nativeBuildInputs = [ pkgconfig intltool ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
