{ stdenv, fetchurl, pkgconfig, libgnome, libgnomecanvas, libbonoboui, libglade }:

assert pkgconfig != null && libgnome != null && libgnomecanvas != null
  && libbonoboui != null && libglade != null;

stdenv.mkDerivation {
  name = "libgnomeui-2.4.0.1";
  src = fetchurl {
    url = http://ftp.gnome.org/pub/GNOME/desktop/2.4/2.4.1/sources/libgnomeui-2.4.0.1.tar.bz2;
    md5 = "196f4a3f1f4a531ff57acaa879e98dd2";
  };
  buildInputs = [pkgconfig libglade];
  propagatedBuildInputs = [libgnome libgnomecanvas libbonoboui];
}
