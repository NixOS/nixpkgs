{ postscriptSupport ? true
, pdfSupport ? true
, pngSupport ? true
, stdenv, fetchurl, pkgconfig, x11, fontconfig, freetype
, zlib, libpng, pixman
}:

assert postscriptSupport -> zlib != null;
assert pngSupport -> libpng != null;

stdenv.mkDerivation rec {
  name = "cairo-1.8.6";
  
  src = fetchurl {
    url = "http://cairographics.org/releases/${name}.tar.gz";
    sha256 = "0d9mfwq7r66j85hqjcjavwbn7c8gdaqnahmmiyz5iwpc1jplg8wk";
  };

  buildInputs = [
    pkgconfig x11 fontconfig pixman
  ];
  
  propagatedBuildInputs =
    [ freetype ] ++
    stdenv.lib.optional postscriptSupport zlib ++
    stdenv.lib.optional pngSupport libpng;
    
  configureFlags =
    (if pdfSupport then ["--enable-pdf"] else []);

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
