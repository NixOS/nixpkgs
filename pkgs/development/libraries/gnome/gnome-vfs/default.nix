{ stdenv, fetchurl, pkgconfig, perl, glib, libxml2, GConf
, libbonobo, gnomemimedata, popt, bzip2 }:

assert pkgconfig != null && perl != null && glib != null
  && libxml2 != null && GConf != null && libbonobo != null
  && gnomemimedata != null && bzip2 != null;

stdenv.mkDerivation {
  name = "gnome-vfs-2.4.1";
  src = fetchurl {
    url = ftp://ftp.gnome.org/pub/gnome/sources/gnome-vfs/2.4/gnome-vfs-2.4.1.tar.bz2;
    md5 = "cb7a36076f6a65e40c7f540be3057310";
  };
  buildInputs = [pkgconfig perl glib libxml2 GConf libbonobo gnomemimedata popt bzip2];
}
