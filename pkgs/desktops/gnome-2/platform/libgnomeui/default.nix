{ stdenv, fetchurl_gnome, pkgconfig, libxml2, xlibs, glib, pango
, intltool, libgnome, libgnomecanvas, libbonoboui, GConf, libtool
, gnome_vfs, gnome_keyring, libglade }:

stdenv.mkDerivation rec {
  name = src.pkgname;
  
  src = fetchurl_gnome {
    project = "libgnomeui";
    major = "2"; minor = "24"; patchlevel = "5";
    sha256 = "03rwbli76crkjl6gp422wrc9lqpl174k56cp9i96b7l8jlj2yddf";
  };
  
  buildNativeInputs = [ pkgconfig intltool ];
  buildInputs =
    [ xlibs.xlibs libxml2 GConf pango glib gnome_keyring libglade libtool ];

  propagatedBuildInputs = [ libgnome libbonoboui libgnomecanvas gnome_vfs ];
}
