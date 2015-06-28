{ stdenv, fetchurl, pkgconfig, intltool, libxfce4util
, gtk, gtksourceview, dbus, dbus_glib, makeWrapper }:

stdenv.mkDerivation rec {
  p_name  = "mousepad";
  ver_maj = "0.4";
  ver_min = "0";

  src = fetchurl {
    url = "mirror://xfce/src/apps/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "60114431eac8db6bb6ce18bd38f1630cccb684375b97a445a1b6fd619848d132";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  buildInputs =
    [ pkgconfig intltool libxfce4util
      gtk gtksourceview dbus dbus_glib makeWrapper
    ];

  preFixup = ''
    wrapProgram "$out/bin/mousepad" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH:${gtksourceview}/share"
  '';

  meta = {
    homepage = http://www.xfce.org/;
    description = "A simple text editor for Xfce";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
