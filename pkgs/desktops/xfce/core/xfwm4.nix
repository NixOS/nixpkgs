{ stdenv, fetchurl, pkgconfig, gtk, intltool, libglade, libxfce4util
, libxfce4ui, xfconf, libwnck, libstartup_notification, xorg }:

stdenv.mkDerivation rec {
  p_name  = "xfwm4";
  ver_maj = "4.12";
  ver_min = "3";

  src = fetchurl {
    url = "mirror://xfce/src/xfce/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "f4a988fbc4e0df7e8583c781d271559e56fd28696092f94ae052e9e6edb09eac";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  buildInputs =
    [ pkgconfig intltool gtk libglade libxfce4util libxfce4ui xfconf
      libwnck libstartup_notification
      xorg.libXcomposite xorg.libXfixes xorg.libXdamage
    ];

  enableParallelBuilding = true;

  meta = {
    homepage = http://www.xfce.org/projects/xfwm4;
    description = "Window manager for Xfce";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
