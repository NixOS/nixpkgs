{ stdenv, fetchurl, pkgconfig, intltool, glib, libxfce4util, dbus_glib }:

stdenv.mkDerivation rec {
  p_name  = "xfconf";
  ver_maj = "4.10";
  ver_min = "0";

  src = fetchurl {
    url = "mirror://xfce/src/xfce/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "0xh520z0qh0ib0ijgnyrgii9h5d4pc53n6mx1chhyzfc86j1jlhp";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  #TODO: no perl bingings yet (ExtUtils::Depends, ExtUtils::PkgConfig, Glib)
  buildInputs = [ pkgconfig intltool glib libxfce4util ];
  propagatedBuildInputs = [ dbus_glib ];

  meta = {
    homepage = http://docs.xfce.org/xfce/xfconf/start;
    description = "Simple client-server configuration storage and query system for Xfce";
    license = stdenv.lib.licenses.gpl2;
  };
}
