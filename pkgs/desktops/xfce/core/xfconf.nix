{ stdenv, fetchurl, pkgconfig, intltool, glib, libxfce4util, dbus-glib }:
let
  p_name  = "xfconf";
  ver_maj = "4.12";
  ver_min = "1";
in
stdenv.mkDerivation rec {
  name = "${p_name}-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://xfce/src/xfce/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "0dns190bwb615wy9ma2654sw4vz1d0rcv061zmaalkv9wmj8bx1m";
  };

  outputs = [ "out" "dev" "devdoc" ];

  #TODO: no perl bingings yet (ExtUtils::Depends, ExtUtils::PkgConfig, Glib)
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ intltool glib libxfce4util ];
  propagatedBuildInputs = [ dbus-glib ];

  meta = with stdenv.lib; {
    homepage = http://docs.xfce.org/xfce/xfconf/start;
    description = "Simple client-server configuration storage and query system for Xfce";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}

