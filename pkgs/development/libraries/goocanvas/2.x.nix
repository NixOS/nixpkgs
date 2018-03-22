{ stdenv, fetchurl, pkgconfig, gettext, gtk-doc, gobjectIntrospection, python2, gtk3, cairo, glib }:

let
  version = "2.0.4";
in stdenv.mkDerivation rec {
  name = "goocanvas-${version}";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/goocanvas/2.0/${name}.tar.xz";
    sha256 = "141fm7mbqib0011zmkv3g8vxcjwa7hypmq71ahdyhnj2sjvy4a67";
  };

  nativeBuildInputs = [ pkgconfig gettext gtk-doc python2 ];
  buildInputs = [ gtk3 cairo glib ];

  configureFlags = [
    "--disable-python"
  ];

  meta = with stdenv.lib; {
    description = "Canvas widget for GTK+ based on the the Cairo 2D library";
    homepage = https://wiki.gnome.org/Projects/GooCanvas;
    license = licenses.lgpl2;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
