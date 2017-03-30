{ fetchurl, stdenv, pkgconfig, gobjectIntrospection, clutter, gtk3 }:

stdenv.mkDerivation rec {
  major = "1.8";
  minor = "2";
  name = "clutter-gtk-${major}.${minor}";

  src = fetchurl {
    url = "mirror://gnome/sources/clutter-gtk/${major}/${name}.tar.xz";
    sha256 = "da27d486325490ad3f65d2abf9413aeb8b4a8f7b559e4b2f73567a5344a26b94";
  };

  propagatedBuildInputs = [ clutter gtk3 ];
  nativeBuildInputs = [ pkgconfig gobjectIntrospection ];

  postBuild = "rm -rf $out/share/gtk-doc";

  meta = {
    description = "Clutter-GTK";
    homepage = http://www.clutter-project.org/;
    license = stdenv.lib.licenses.lgpl2Plus;
    maintainers = with stdenv.lib.maintainers; [ lethalman ];
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}
