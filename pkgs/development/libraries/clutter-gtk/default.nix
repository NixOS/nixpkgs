{ fetchurl, stdenv, pkgconfig, gobjectIntrospection, clutter, gtk3 }:

stdenv.mkDerivation rec {
  major = "1.8";
  minor = "4";
  name = "clutter-gtk-${major}.${minor}";

  src = fetchurl {
    url = "mirror://gnome/sources/clutter-gtk/${major}/${name}.tar.xz";
    sha256 = "01ibniy4ich0fgpam53q252idm7f4fn5xg5qvizcfww90gn9652j";
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
