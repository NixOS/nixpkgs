{ fetchurl, stdenv, pkgconfig, cairo, x11, fontconfig, freetype, libsigcxx }:

stdenv.mkDerivation rec {
  name = "cairomm-1.7.2";

  src = fetchurl {
    url = "http://cairographics.org/releases/${name}.tar.gz";
    sha256 = "0rcbkk16yj9k1y491ms5j6f9z5wrvv4qkd7wbx44nziwhw6hc0qx";
  };

  buildInputs = [pkgconfig];
  
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

    licenses = [ "LGPLv2+" "MPLv1" ];
  };
}
