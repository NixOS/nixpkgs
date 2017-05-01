{ stdenv, fetchurl, pkgconfig, intltool, xfce4panel, libxfce4util, gtk, libsoup
, makeWrapper, glib_networking, exo, hicolor_icon_theme, wrapGAppsHook }:

stdenv.mkDerivation rec {
  p_name  = "xfce4-screenshooter";
  ver_maj = "1.8";
  ver_min = "2";

  src = fetchurl {
    url = "mirror://xfce/src/apps/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "9dce2ddfaa87f703e870e29bae13f3fc82a1b3f06b44f8386640e45a135f5f69";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  nativeBuildInputs = [
    pkgconfig intltool wrapGAppsHook
  ];

  buildInputs = [
    xfce4panel libxfce4util gtk libsoup exo hicolor_icon_theme glib_networking
  ];

  meta = {
    homepage = http://goodies.xfce.org/projects/applications/xfce4-screenshooter;
    description = "Xfce screenshooter";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
