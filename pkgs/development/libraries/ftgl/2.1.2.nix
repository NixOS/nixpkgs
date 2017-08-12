{stdenv, fetchurl, freetype, mesa}:

let
  name = "ftgl-2.1.2";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "mirror://sourceforge/ftgl/${name}.tar.gz";
    sha256 = "0xa00fnn6wd3rnkrkcs1wpv21lxdsb83r4hjn3l33dn0zbawnn97";
  };

  buildInputs = [freetype mesa];

  NIX_LDFLAGS = "-lGLU -lGL";

  patches = [ ./gcc.patch ];

  configureFlags = "--enable-shared";

  preConfigure = ''
    cd unix
    cd docs
    tar vxf ../../docs/html.tar.gz
    cd ..
  '';

  meta = {
    homepage = http://sourceforge.net/apps/mediawiki/ftgl/;
    description = "Font rendering library for OpenGL applications";
    license = stdenv.lib.licenses.gpl3Plus;

    longDescription = ''
      FTGL is a free cross-platform Open Source C++ library that uses
      Freetype2 to simplify rendering fonts in OpenGL applications. FTGL
      supports bitmaps, pixmaps, texture maps, outlines, polygon mesh,
      and extruded polygon rendering modes.
    '';

    platforms = stdenv.lib.platforms.gnu;
    maintainers = [];
  };
}
