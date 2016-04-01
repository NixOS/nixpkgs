{ fetchurl, stdenv, pkgconfig, gobjectIntrospection, clutter, gtk3 }:

stdenv.mkDerivation rec {
  major = "1.8";
  minor = "0";
  name = "clutter-gtk-${major}.${minor}";

  src = fetchurl {
    url = "mirror://gnome/sources/clutter-gtk/${major}/${name}.tar.xz";
    sha256 = "bc3108594a01a08bb6d9b538afe995e4fd78634a8356064ee8137d87aad51b2e";
  };

  propagatedBuildInputs = [ clutter gtk3 ];
  nativeBuildInputs = [ pkgconfig gobjectIntrospection ];

  postBuild = "rm -rf $out/share/gtk-doc";

  meta = {
    description = "Clutter-GTK";
    homepage = http://www.clutter-project.org/;
    license = stdenv.lib.licenses.lgpl2Plus;
    maintainers = with stdenv.lib.maintainers; [ urkud lethalman ];
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}
