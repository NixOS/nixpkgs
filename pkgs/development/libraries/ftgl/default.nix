{stdenv, fetchurl, freetype, libGLU_combined}:

let
  name = "ftgl-2.1.3-rc5";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "mirror://sourceforge/ftgl/${name}.tar.gz";
    sha256 = "0nsn4s6vnv5xcgxcw6q031amvh2zfj2smy1r5mbnjj2548hxcn2l";
  };

  buildInputs = [ freetype libGLU_combined ];

  enableParallelBuilding = true;

  meta = {
    homepage = https://sourceforge.net/apps/mediawiki/ftgl/;
    description = "Font rendering library for OpenGL applications";
    license = stdenv.lib.licenses.gpl3Plus;

    longDescription = ''
      FTGL is a free cross-platform Open Source C++ library that uses
      Freetype2 to simplify rendering fonts in OpenGL applications. FTGL
      supports bitmaps, pixmaps, texture maps, outlines, polygon mesh,
      and extruded polygon rendering modes.
    '';

    platforms = stdenv.lib.platforms.unix;
    maintainers = [];
  };
}
