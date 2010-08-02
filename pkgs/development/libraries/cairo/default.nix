{ postscriptSupport ? true
, pdfSupport ? true
, pngSupport ? true
, xcbSupport ? false
, stdenv, fetchurl, pkgconfig, x11, fontconfig, freetype
, zlib, libpng, pixman, libxcb ? null, xcbutil ? null
}:

assert postscriptSupport -> zlib != null;
assert pngSupport -> libpng != null;
assert xcbSupport -> libxcb != null && xcbutil != null;

stdenv.mkDerivation rec {
  name = "cairo-1.8.10";
  
  src = fetchurl {
    url = "http://cairographics.org/releases/${name}.tar.gz";
    sha1 = "fd5e8ca82ff0e8542ea4c51612cad387f2a49df3";
  };

  buildInputs =
    [ pkgconfig x11 fontconfig pixman ] ++ 
    stdenv.lib.optionals xcbSupport [ libxcb xcbutil ];

  propagatedBuildInputs =
    [ freetype ] ++
    stdenv.lib.optional postscriptSupport zlib ++
    stdenv.lib.optional pngSupport libpng;
    
  configureFlags =
    stdenv.lib.optional xcbSupport "--enable-xcb" ++
    stdenv.lib.optional pdfSupport "--enable-pdf";

  preConfigure = ''
    # Work around broken `Requires.private' that prevents Freetype
    # `-I' flags to be propagated.
    sed -i "src/cairo.pc.in" \
        -es'|^Cflags:\(.*\)$|Cflags: \1 -I${freetype}/include/freetype2 -I${freetype}/include|g'
  '';

  meta = {
    description = "A 2D graphics library with support for multiple output devices";

    longDescription = ''
      Cairo is a 2D graphics library with support for multiple output
      devices.  Currently supported output targets include the X
      Window System, Quartz, Win32, image buffers, PostScript, PDF,
      and SVG file output.  Experimental backends include OpenGL
      (through glitz), XCB, BeOS, OS/2, and DirectFB.

      Cairo is designed to produce consistent output on all output
      media while taking advantage of display hardware acceleration
      when available (e.g., through the X Render Extension).
    '';

    homepage = http://cairographics.org/;

    licenses = [ "LGPLv2+" "MPLv1" ];
  };
}
