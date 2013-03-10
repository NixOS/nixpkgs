{ stdenv, fetchurl, pkgconfig, python, libxml2Python, libxslt, which, libX11, gnome3
, intltool, gnome_doc_utils}:

stdenv.mkDerivation rec {

  majorVersion = "3.5";
  minorVersion = "3";
  name = "gnome-desktop-${majorVersion}.${minorVersion}";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-desktop/${majorVersion}/${name}.tar.xz";
    sha256 = "1nrqcp1p5cxhfjjy5hjpvkqmzsgl2353a08fg0b11c932v95bsba";
  };

  configureFlags = "--disable-scrollkeeper";
  buildInputs = [ pkgconfig python libxml2Python libxslt which libX11
                  gnome3.gtk gnome3.glib intltool gnome_doc_utils ];
}
