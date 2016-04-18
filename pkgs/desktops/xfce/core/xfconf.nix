{ stdenv, fetchurl, pkgconfig, intltool, glib, libxfce4util, dbus_glib }:
let
  p_name  = "xfconf";
  ver_maj = "4.12";
  ver_min = "0";
in
stdenv.mkDerivation rec {
  name = "${p_name}-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://xfce/src/xfce/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "0mmi0g30aln3x98y5p507g17pipq0dj0bwypshan8cq5hkmfl44r";
  };

  outputs = [ "dev" "out" "docdev" ];

  #TODO: no perl bingings yet (ExtUtils::Depends, ExtUtils::PkgConfig, Glib)
  buildInputs = [ pkgconfig intltool glib libxfce4util ];
  propagatedBuildInputs = [ dbus_glib ];

  meta = with stdenv.lib; {
    homepage = http://docs.xfce.org/xfce/xfconf/start;
    description = "Simple client-server configuration storage and query system for Xfce";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}

