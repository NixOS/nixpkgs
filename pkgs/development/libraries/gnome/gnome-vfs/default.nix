{ stdenv, fetchurl, pkgconfig, perl, glib, libxml2, GConf
, libbonobo, gnomemimedata, popt, bzip2, perlXMLParser }:

assert pkgconfig != null && perl != null && glib != null
  && libxml2 != null && GConf != null && libbonobo != null
  && gnomemimedata != null && bzip2 != null;

stdenv.mkDerivation {
  name = "gnome-vfs-2.4.2";
  src = fetchurl {
    url = ftp://ftp.gnome.org/pub/gnome/sources/gnome-vfs/2.4/gnome-vfs-2.4.2.tar.bz2;
    md5 = "a0f0e40739214143bbf3050311ff10cd";
  };
  buildInputs = [
    pkgconfig perl glib libxml2 GConf libbonobo
    gnomemimedata popt bzip2 perlXMLParser
  ];
  PERL5LIB = perlXMLParser ~ "/lib/site_perl";
}
