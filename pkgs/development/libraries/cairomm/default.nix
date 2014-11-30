{ fetchurl, stdenv, pkgconfig, cairo, x11, fontconfig, freetype, libsigcxx }:

stdenv.mkDerivation rec {
  name = "cairomm-1.11.2";

  src = fetchurl {
    url = "http://cairographics.org/releases/${name}.tar.gz";
    sha1 = "35e190a03f760924bece5dc1204cc36b3583c806";
  };

  buildInputs = [ pkgconfig ];

  propagatedBuildInputs = [ cairo x11 fontconfig freetype libsigcxx ];

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

    license = [ "LGPLv2+" "MPLv1" ];
  };
}
