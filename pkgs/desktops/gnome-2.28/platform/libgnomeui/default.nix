{ stdenv, fetchurl, pkgconfig, libxml2, xlibs, glib, pango
, intltool, libgnome, libgnomecanvas, libbonoboui, GConf
, gnome_vfs, gnome_keyring, libglade }:

stdenv.mkDerivation {
  name = "libgnomeui-2.24.2";
  
  src = fetchurl {
    url = mirror://gnome/sources/libgnomeui/2.24/libgnomeui-2.24.2.tar.bz2;
    sha256 = "04296nf6agg8zsbw6pzl3mzn890bkcczs6fnna5jay7fvnrmjx5f";
  };
  
  buildInputs = [ pkgconfig intltool xlibs.xlibs libxml2 GConf pango glib gnome_keyring libglade ];

  propagatedBuildInputs = [ libgnome libbonoboui libgnomecanvas gnome_vfs ];
}
