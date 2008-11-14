{ stdenv, fetchurl, pkgconfig, mono
, glib
, pango
, gtk
, GConf ? null
, libglade ? null
, libgtkhtml ? null
, gtkhtml ? null
, libgnomecanvas ? null
, libgnomeui ? null
, libgnomeprint ? null
, libgnomeprintui ? null
, libxml2
, monoDLLFixer
}:

stdenv.mkDerivation {
  name = "gtk-sharp-1.0.6";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://nixos.org/tarballs/gtk-sharp-1.0.6.tar.gz;
    md5 = "2651d14fe77174ab20b8af53d150ee11";
  };

  patches = [ ./dllmap-glue.patch ];

  buildInputs = [
    pkgconfig mono glib pango gtk GConf libglade libgnomecanvas
    libgtkhtml libgnomeui libgnomeprint libgnomeprintui gtkhtml libxml2
  ];

  inherit monoDLLFixer;
}
