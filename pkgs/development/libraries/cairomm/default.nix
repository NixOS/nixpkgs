{ fetchurl, stdenv, pkgconfig, cairo, xlibsWrapper, fontconfig, freetype, libsigcxx }:
let
  ver_maj = "1.12";
  ver_min = "0";
in
stdenv.mkDerivation rec {
  name = "cairomm-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://gnome/sources/cairomm/${ver_maj}/${name}.tar.xz";
    sha256 = "a54ada8394a86182525c0762e6f50db6b9212a2109280d13ec6a0b29bfd1afe6";
  };

  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ cairo libsigcxx ];
  buildInputs = [ fontconfig freetype ];

  doCheck = true;

  meta = with stdenv.lib; {
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

    license = with licenses; [ lgpl2Plus mpl10 ];
  };
}
