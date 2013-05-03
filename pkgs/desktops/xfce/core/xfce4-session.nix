{ stdenv, fetchurl, pkgconfig, intltool, gtk, libxfce4util, libxfce4ui, xfce4panel
, libwnck, dbus_glib, xfconf, libglade, xorg
, polkit, xfce4_dev_tools }:

#TODO: gnome stuff: gconf (assistive?), keyring

stdenv.mkDerivation rec {
  p_name  = "xfce4-session";
  ver_maj = "4.10";
  ver_min = "0";

  src = fetchurl {
    url = "mirror://xfce/src/xfce/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "1kj65jkjhd0ysf0yxsf88wzpyv6n8i8qgd3gb502hf1x9jksk2mv";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  patch_crash = fetchurl {
    url = "http://git.xfce.org/xfce/xfce4-session/patch/?id=ab391138cacc62ab184a338e237c4430356b41f9";
    sha256 = "1kydj52hm883rdanpcqzf5qphj0ws2v28g8fim8jv2pm72d33day";
  };

  patches = [ ./xfce4-session-systemd.patch patch_crash ];

  buildInputs =
    [ pkgconfig intltool gtk libxfce4util libxfce4ui libwnck dbus_glib
      xfconf xfce4panel libglade xorg.iceauth
      polkit xfce4_dev_tools
    ];

  preConfigure = "xdt-autogen";
  configureFlags = [ "--with-xsession-prefix=$(out)" ];

  preFixup = "rm $out/share/icons/hicolor/icon-theme.cache";

  meta = {
    homepage = http://www.xfce.org/projects/xfce4-session;
    description = "Session manager for Xfce";
    license = "GPLv2+";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
