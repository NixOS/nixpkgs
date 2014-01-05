{ stdenv, fetchurl, mesa, libX11, libXext }:

stdenv.mkDerivation {
  name = "glfw-2.7.9";

  src = fetchurl {
    url = mirror://sourceforge/glfw/glfw-2.7.9.tar.bz2;
    sha256 = "17c2msdcb7pn3p8f83805h1c216bmdqnbn9hgzr1j8wnwjcpxx6i";
  };

  buildInputs = [ mesa libX11 libXext ];

  buildPhase = ''
    mkdir -p $out
    make x11-install PREFIX=$out
  '';
  
  installPhase = ":";

  meta = { 
    description = "Multi-platform library for creating OpenGL contexts and managing input, including keyboard, mouse, joystick and time";
    homepage = http://glfw.sourceforge.net/;
    license = "zlib/libpng"; # http://www.opensource.org/licenses/zlib-license.php
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };
}
