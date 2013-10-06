{ stdenv, fetchurl, pkgconfig, intltool, gtk, dbus_glib, xfconf
, libxfce4ui, libxfce4util, libnotify, xfce4panel }:

stdenv.mkDerivation rec {
  p_name  = "xfce4-power-manager";
  ver_maj = "1.2";
  ver_min = "0";

  src = fetchurl {
    url = "mirror://xfce/src/xfce/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "1sc4f4wci5yl3l9lk7vcsbwj6hdjshbxw9qm43s64jr882jriyyp";
  };

  brightness_patch = fetchurl {
    url = "http://git.xfce.org/xfce/xfce4-power-manager/patch/?id=05d12e12596512f7a31d3cdb4845a69dc2d4c611";
    sha256 = "0rbldvjwpj93hx59xrmvbdql1pgkbqzjh4vp6gkavn4z6sv535v8";
  };

  name = "${p_name}-${ver_maj}.${ver_min}";

  buildInputs =
    [ pkgconfig intltool gtk dbus_glib xfconf libxfce4ui libxfce4util
      libnotify xfce4panel
    ];
  preFixup = "rm $out/share/icons/hicolor/icon-theme.cache";

  patches = [ brightness_patch ];

  meta = {
    homepage = http://goodies.xfce.org/projects/applications/xfce4-power-manager;
    description = "A power manager for the Xfce Desktop Environment";
    license = "GPLv2+";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
