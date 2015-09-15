{ stdenv, fetchurl, pkgconfig, libxml2, xorg, glib, pango
, intltool, libgnome, libgnomecanvas, libbonoboui, GConf, libtool
, gnome_vfs, libgnome_keyring, libglade }:

stdenv.mkDerivation rec {
  name = "libgnomeui-${minVer}.5";
  minVer = "2.24";

  src = fetchurl {
    url = "mirror://gnome/sources/libgnomeui/${minVer}/${name}.tar.bz2";
    sha256 = "03rwbli76crkjl6gp422wrc9lqpl174k56cp9i96b7l8jlj2yddf";
  };

  nativeBuildInputs = [ pkgconfig intltool ];
  buildInputs =
    [ xorg.xlibsWrapper libxml2 GConf pango glib libgnome_keyring libglade libtool ];

  propagatedBuildInputs = [ libgnome libbonoboui libgnomecanvas gnome_vfs ];
}
