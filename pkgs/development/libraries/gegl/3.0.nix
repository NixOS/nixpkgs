{ stdenv, fetchgit, pkgconfig, glib, babl, libpng, cairo, libjpeg, which
, librsvg, pango, gtk, bzip2, intltool, libtool, automake, autoconf, json_glib }:

stdenv.mkDerivation rec {
  name = "gegl-0.3.0-20140619";

  src = fetchgit {
    url = "https://git.gnome.org/browse/gegl";
    sha256 = "1rjmv2y7z34zrnlqczmmh0bm724iszzdf6jpibszxnp3w0npwjrb";
    rev = "0014eb1bad50244314ed09592fe57efa9322678c";
  };

  configureScript = "./autogen.sh";

  # needs fonts otherwise  don't know how to pass them
  configureFlags = "--disable-docs";

  buildInputs = [ babl libpng cairo libjpeg librsvg pango gtk bzip2 intltool
                  autoconf automake libtool which json_glib ];

  nativeBuildInputs = [ pkgconfig ];

  meta = { 
    description = "Graph-based image processing framework";
    homepage = http://www.gegl.org;
    license = stdenv.lib.licenses.gpl3;
  };
}
