{ stdenv, fetchgit, autoconf, automake, which, pkgconfig, libtool, glib, babl
, libpng, cairo, libjpeg, librsvg, pango, gtk, bzip2, intltool, openexr, lua
, libwebp, vala, enscript, SDL, graphviz, exiv2, libav, asciidoc }:

stdenv.mkDerivation rec {
  rev = "b9b2f3553a5b744c82b9ca89fa75b397fd08d6c7";
  name = "gegl-${rev}";

  src = fetchgit {
    inherit rev;
    url = "git://git.gnome.org/gegl";
    sha256 = "143k8d5fj96dhznbl2dq1iwiawvni5acp01l2f6bv4n8fid395wa";
  };

  preConfigure = "./autogen.sh";

  configureFlags = "--disable-docs";

  buildInputs =
    [ autoconf automake which libtool babl libpng cairo libjpeg librsvg pango
      gtk bzip2 intltool openexr lua libwebp vala enscript SDL graphviz exiv2
      libav asciidoc
    ];

  nativeBuildInputs = [ pkgconfig ];

  meta = {
    description = "Graph-based image processing framework";
    homepage = http://www.gegl.org;
    license = stdenv.lib.licenses.gpl3;
    # NOTE: might be usable for other platforms too
    platforms = stdenv.lib.platforms.linux;
    hydraPlatforms = [];
    maintainers = [ stdenv.lib.maintainers.flosse ];
  };
}
