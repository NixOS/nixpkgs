{ stdenv, fetchurl, pkgconfig, gtk, intltool, libglade, libxfce4util
, libxfce4ui, xfconf, libwnck, libstartup_notification, xorg }:
let
  p_name  = "xfwm4";
  ver_maj = "4.12";
  ver_min = "4";
in
stdenv.mkDerivation rec {
  name = "${p_name}-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://xfce/src/xfce/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "0dpvdrd5lclkcrzmdpva38gfsgvdf3xkqfknvy96x6k4fn508x7s";
  };

  buildInputs =
    [ pkgconfig intltool gtk libglade libxfce4util libxfce4ui xfconf
      libwnck libstartup_notification
      xorg.libXcomposite xorg.libXfixes xorg.libXdamage
    ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://www.xfce.org/projects/xfwm4;
    description = "Window manager for Xfce";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.eelco ];
  };
}

