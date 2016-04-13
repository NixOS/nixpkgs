{ stdenv, fetchurl, fetchpatch, pkgconfig, intltool, gtk, polkit
, libxfce4util, libxfce4ui, xfce4panel, libwnck, dbus_glib, xfconf, libglade, xorg
, hicolor_icon_theme
}:

let
  p_name  = "xfce4-session";
  ver_maj = "4.12";
  ver_min = "1";
in
stdenv.mkDerivation rec {
  name = "${p_name}-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://xfce/src/xfce/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "97d7f2a2d0af7f3623b68d1f04091e02913b28f9555dab8b0d26c8a1299d08fd";
  };

  buildInputs =
    [ pkgconfig intltool gtk libxfce4util libxfce4ui libwnck dbus_glib
      xfconf xfce4panel libglade xorg.iceauth xorg.libSM
      polkit hicolor_icon_theme
    ]; #TODO: upower-glib, gconf (assistive?), gnome keyring

  preBuild = ''
    sed '/^PATH=/d'        -i scripts/xflock4
    sed '/^export PATH$/d' -i scripts/xflock4
  '';

  configureFlags = [ "--with-xsession-prefix=$(out)" ];

  meta = with stdenv.lib; {
    homepage = http://www.xfce.org/projects/xfce4-session;
    description = "Session manager for Xfce";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.eelco ];
  };
}

