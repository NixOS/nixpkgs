args: with args;

stdenv.mkDerivation {
  name = "libgsf-1.14.7";
  src = fetchurl {
    url = http://ftp.gnome.org/pub/gnome/sources/libgsf/1.14/libgsf-1.14.7.tar.bz2;
	sha256 = "0vd8arjaavb3qywd9cm2gdn6ngrlyd99nlsj72par8fm60k48bhq";
  };
  buildInputs = [perl perlXMLParser pkgconfig libxml2 glib gettext bzip2
  gnomevfs libbonobo];
}
