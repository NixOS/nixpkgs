{ stdenv, fetchurl, pkgconfig, intltool, gtk, libxfce4util, libxfce4ui
, libwnck, xfconf, libglade, xfce4panel, thunar, exo, garcon, libnotify
, hicolor_icon_theme }:
let
  p_name  = "xfdesktop";
  ver_maj = "4.12";
  ver_min = "3";
in
stdenv.mkDerivation rec {
  name = "${p_name}-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://xfce/src/xfce/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "a8a8d93744d842ca6ac1f9bd2c8789ee178937bca7e170e5239cbdbef30520ac";
  };

  buildInputs =
    [ pkgconfig intltool gtk libxfce4util libxfce4ui libwnck xfconf
      libglade xfce4panel thunar exo garcon libnotify hicolor_icon_theme
    ];

  patches =
    [
      (fetchurl {
      url = https://git.xfce.org/users/eric/xfdesktop/patch/?id=cc311b61b82b7510a3a6cb0952d3a331e3551e05;
      sha256 = "0wil8533v0hag5b6vn5qjx7nlw9h643idzbkjdxd910483la94vz";})
    ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://www.xfce.org/projects/xfdesktop;
    description = "Xfce desktop manager";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.eelco ];
  };
}
