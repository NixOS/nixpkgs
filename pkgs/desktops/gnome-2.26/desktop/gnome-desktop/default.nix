{ stdenv, fetchurl, pkgconfig, python, libxml2, libxslt, which, libX11, gtk
, intltool, GConf, gnome_doc_utils}:

stdenv.mkDerivation {
  name = "gnome-desktop-2.26.2";
  src = fetchurl {
    url = mirror://gnome/desktop/2.26/2.26.2/sources/gnome-desktop-2.26.2.tar.bz2;
    sha256 = "0aphqbrgczcng1wgkgjkcy5nw88y407d4flcs0bszicqrvzsyl2d";
  };
  configureFlags = "--disable-scrollkeeper";
  buildInputs = [ pkgconfig python libxml2 libxslt which libX11 gtk
                  intltool GConf gnome_doc_utils ];
}
