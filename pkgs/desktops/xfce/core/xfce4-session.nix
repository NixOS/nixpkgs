{ stdenv, fetchurl, pkgconfig, intltool, gtk, libxfce4util, libxfce4ui, xfce4panel
, libwnck, dbus_glib, xfconf, libglade, xorg }:

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

  buildInputs =
    [ pkgconfig intltool gtk libxfce4util libxfce4ui libwnck dbus_glib
      xfconf xfce4panel libglade xorg.iceauth
    ];

  configureFlags = [ "--with-xsession-prefix=$$out" ];

  preFixup = "rm $out/share/icons/hicolor/icon-theme.cache";

  meta = {
    homepage = http://www.xfce.org/projects/xfce4-session;
    description = "Session manager for Xfce";
    license = "GPLv2+";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
