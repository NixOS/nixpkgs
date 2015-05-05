{ fetchurl, stdenv, pkgconfig, gobjectIntrospection, clutter, gtk3 }:

stdenv.mkDerivation rec {
  name = "clutter-gtk-1.6.0";

  src = fetchurl {
    url = "mirror://gnome/sources/clutter-gtk/1.6/${name}.tar.xz";
    sha256 = "883550b574a036363239442edceb61cf3f6bedc8adc97d3404278556dc82234d";
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
