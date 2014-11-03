{ stdenv, fetchurl, pkgconfig, thunar, intltool, exo, gtk, udev, libxfce4ui, libxfce4util, xfconf }:

stdenv.mkDerivation rec {
  name  = "thunar-archive-plugin-${version}";
  maj_ver = "0.3";
  version = "${maj_ver}.1";

  src = fetchurl {
    url = "mirror://xfce/src/thunar-plugins/${name}/${maj_ver}/${name}.tar.bz2";
    sha256 = "1sxw09fwyn5sr6ipxk7r8gqjyf41c2v7vkgl0l6mhy5mcb48f27z";
  };

  buildInputs = [ pkgconfig thunar intltool exo gtk udev libxfce4ui libxfce4util xfconf ];
  enableParallelBuilding = true;

  preFixup = "rm $out/share/icons/hicolor/icon-theme.cache";

  meta = {
    homepage = http://foo-projects.org/~benny/projects/thunar-archive-plugin/;
    description = "The Thunar Archive Plugin allows you to create and extract archive files using the file context menus in the Thunar file manager";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.iElectric ];
  };
}
