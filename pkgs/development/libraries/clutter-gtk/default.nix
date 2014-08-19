{ fetchurl, stdenv, pkgconfig, gobjectIntrospection, clutter, gtk3 }:

stdenv.mkDerivation rec {
  name = "clutter-gtk-1.4.4";

  src = fetchurl {
    url = "mirror://gnome/sources/clutter-gtk/1.4/${name}.tar.xz";
    sha256 = "bc3108594a01a08bb6d9b538afe995e4fd78634a8356064ee8137d87aad51b2e";
  };

  propagatedBuildInputs = [ clutter gtk3 ];
  nativeBuildInputs = [ pkgconfig gobjectIntrospection ];

  postBuild = "rm -rf $out/share/gtk-doc";

  meta = {
    description = "Clutter-GTK";

    homepage = http://www.clutter-project.org/;

    license = stdenv.lib.licenses.lgpl2Plus;

    maintainers = with stdenv.lib.maintainers; [ urkud ];
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}
