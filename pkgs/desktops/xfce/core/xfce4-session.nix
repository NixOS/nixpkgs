{ stdenv, fetchurl, fetchpatch, pkgconfig, intltool, gtk, polkit
, libxfce4util, libxfce4ui, xfce4panel, libwnck, dbus_glib, xfconf, libglade, xorg
}:

#TODO: gnome stuff: gconf (assistive?), keyring

stdenv.mkDerivation rec {
  p_name  = "xfce4-session";
  ver_maj = "4.10";
  ver_min = "1";

  src = fetchurl {
    url = "mirror://xfce/src/xfce/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "10zwki7v55a325abr57wczcb5g7ml99cqk1p8ls8qycqqfyzlm01";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  patches = [(fetchpatch {
    name = "suspend+hibernate-via-logind.patch";
    url = "https://projects.archlinux.org/svntogit/packages.git/plain/trunk/"
      + "xfce4-session-4.10.1-logind-support-for-suspend-hibernate.patch"
      + "?h=packages/xfce4-session&id=f84637fa2b";
    sha256 = "1pnm1w9invyxjdbfm7p0brf9krl9jy8ab2ilwvizymp5i0vnj0xc";
  })];

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
