{ stdenv, fetchurl, pkgconfig, python, libxml2Python, libxslt, which, libX11, gtk
, intltool, GConf, gnome-doc-utils}:

stdenv.mkDerivation {
  name = "gnome-desktop-2.32.1";

  src = fetchurl {
    url = mirror://gnome/sources/gnome-desktop/2.32/gnome-desktop-2.32.1.tar.bz2;
    sha256 = "17bkng6ay37n3492lr9wpb49kms6gh554rn9gbjs27zygvvfrjsm";
  };

  configureFlags = "--disable-scrollkeeper";
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ python libxml2Python libxslt which libX11 gtk
                  intltool GConf gnome-doc-utils ];
}
