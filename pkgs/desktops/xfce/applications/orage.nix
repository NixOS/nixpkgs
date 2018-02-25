{ stdenv, fetchurl, pkgconfig, bison, flex, intltool, gtk, libical, dbus-glib
, libnotify, popt, xfce
}:

stdenv.mkDerivation rec {
  name = "${p_name}-${ver_maj}.${ver_min}";
  p_name  = "orage";
  ver_maj = "4.12";
  ver_min = "1";

  src = fetchurl {
    url = "mirror://xfce/src/apps/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "0qlhvnl2m33vfxqlbkic2nmfpwyd4mq230jzhs48cg78392amy9w";
  };

  nativeBuildInputs = [ pkgconfig intltool bison flex ];
  
  buildInputs = [ gtk libical dbus-glib libnotify popt xfce.libxfce4util
    xfce.xfce4panel ];

  preFixup = "rm $out/share/icons/hicolor/icon-theme.cache ";

  meta = {
    homepage = http://www.xfce.org/projects/;
    description = "A simple calendar application with reminders";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
