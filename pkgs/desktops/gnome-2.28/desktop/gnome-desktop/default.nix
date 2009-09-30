{ stdenv, fetchurl, pkgconfig, python, libxml2, libxslt, which, libX11, gtk
, intltool, GConf, gnome_doc_utils}:

stdenv.mkDerivation {
  name = "gnome-desktop-2.28.0";
  src = fetchurl {
    url = mirror://gnome/sources/gnome-desktop/2.28/gnome-desktop-2.28.0.tar.bz2;
    sha256 = "1raag5c74pyy0f1i37fjxyxcnk9ck4mh6c1hcdmv5dv40xndwvwp";
  };
  configureFlags = "--disable-scrollkeeper";
  buildInputs = [ pkgconfig python libxml2 libxslt which libX11 gtk
                  intltool GConf gnome_doc_utils ];
}
