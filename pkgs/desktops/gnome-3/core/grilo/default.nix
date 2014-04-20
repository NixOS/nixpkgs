{ stdenv, fetchurl, pkgconfig, file, intltool, glib, libxml2, gnome3 }:

stdenv.mkDerivation rec {
  name = "grilo-0.2.10";

  src = fetchurl {
    url = "mirror://gnome/sources/grilo/0.2/${name}.tar.xz";
    sha256 = "559a2470fe541b0090bcfdfac7a33e92dba967727bbab6d0eca70e5636a77b25";
  };

  configureFlags = [ "--enable-grl-pls" ];

  buildInputs = [ pkgconfig file intltool glib libxml2 gnome3.totem-pl-parser ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/action/show/Projects/Grilo;
    description = "Framework that provides access to various sources of multimedia content, using a pluggable system";
    maintainers = with maintainers; [ lethalman ];
    license = licenses.lgpl2;
    platforms = platforms.linux;
  };
}
