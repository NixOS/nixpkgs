{ stdenv, fetchurl, pkgconfig, intltool, xfce4panel, libxfce4util, gtk, libsoup
, exo}:

stdenv.mkDerivation rec {
  p_name  = "xfce4-screenshooter";
  ver_maj = "1.8";
  ver_min = "1";

  src = fetchurl {
    url = "mirror://xfce/src/apps/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "40419892bd28989315eed053c159bba0f4264ed8c6c6738806024e481eab9492";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  buildInputs = [
    pkgconfig intltool xfce4panel libxfce4util gtk libsoup exo
  ];

  meta = {
    homepage = http://goodies.xfce.org/projects/applications/xfce4-screenshooter;
    description = "Xfce screenshooter";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
