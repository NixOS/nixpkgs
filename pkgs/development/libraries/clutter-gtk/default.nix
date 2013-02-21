{ fetchurl, stdenv, pkgconfig, clutter, gtk3 }:

stdenv.mkDerivation rec {
  name = "clutter-gtk-1.0.4";

  src = fetchurl {
    url = mirror://gnome/sources/clutter-gtk/1.0/clutter-gtk-1.0.4.tar.xz;
    sha256 = "0kj6vsvaqxx6vqqk9acc8b0p40klrpwlf2wsjkams1kxxcpzsh87";
  };

  propagatedBuildInputs = [ clutter gtk3 ];
  nativeBuildInputs = [ pkgconfig ];

  postBuild = "rm -rf $out/share/gtk-doc";

  meta = {
    description = "Clutter-GTK";

    homepage = http://www.clutter-project.org/;

    license = "LGPLv2+";

    maintainers = with stdenv.lib.maintainers; [ urkud ludo ];
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}
