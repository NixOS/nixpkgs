{ stdenv, fetchurl, fetchpatch, pkgconfig, intltool, gtk, polkit
, libxfce4util, libxfce4ui, xfce4panel, libwnck, dbus_glib, xfconf, libglade, xorg
}:

#TODO: gnome stuff: gconf (assistive?), keyring

stdenv.mkDerivation rec {
  p_name  = "xfce4-session";
  ver_maj = "4.12";
  ver_min = "0";

  src = fetchurl {
    url = "mirror://xfce/src/xfce/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "01kvbd09c06j20n155hracsgrq06rlmfgdywffjsvlwpn19m9j38";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  buildInputs =
    [ pkgconfig intltool gtk libxfce4util libxfce4ui libwnck dbus_glib
      xfconf xfce4panel libglade xorg.iceauth
      polkit
    ];

  preBuild = ''
    sed '/^PATH=/d'        -i scripts/xflock4
    sed '/^export PATH$/d' -i scripts/xflock4
  '';

  configureFlags = [ "--with-xsession-prefix=$(out)" ];

  preFixup = "rm $out/share/icons/hicolor/icon-theme.cache";

  meta = {
    homepage = http://www.xfce.org/projects/xfce4-session;
    description = "Session manager for Xfce";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
