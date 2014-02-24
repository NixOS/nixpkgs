{ fetchurl, stdenv, pkgconfig, clutter, gtk3, glib, cogl }:

stdenv.mkDerivation rec {
  name = "clutter-gst-2.0.10";

  src = fetchurl {
    url = "mirror://gnome/sources/clutter-gst/2.0/${name}.tar.xz";
    sha256 = "f00cf492a6d4f1036c70d8a0ebd2f0f47586ea9a9b49b1ffda79c9dc7eadca00";
  };

  propagatedBuildInputs = [ clutter gtk3 glib cogl ];
  nativeBuildInputs = [ pkgconfig ];

  postBuild = "rm -rf $out/share/gtk-doc";

  meta = {
    description = "Clutter-GST";

    homepage = http://www.clutter-project.org/;

    license = "LGPLv2+";

    maintainers = with stdenv.lib.maintainers; [ lethalman ];
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}
