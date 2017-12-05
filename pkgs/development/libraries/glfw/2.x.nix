{ stdenv, fetchurl, mesa, libX11 }:

stdenv.mkDerivation rec {
  name = "glfw-2.7.9";

  src = fetchurl {
    url = "mirror://sourceforge/glfw/${name}.tar.bz2";
    sha256 = "17c2msdcb7pn3p8f83805h1c216bmdqnbn9hgzr1j8wnwjcpxx6i";
  };

  buildInputs = [ mesa libX11 ];

  buildPhase = ''
    make x11
  '';

  installPhase = ''
    mkdir -p $out
    make x11-dist-install PREFIX=$out
    mv $out/lib/libglfw.so $out/lib/libglfw.so.2
    ln -s libglfw.so.2 $out/lib/libglfw.so
  ''; 
  
  meta = with stdenv.lib; { 
    description = "Multi-platform library for creating OpenGL contexts and managing input, including keyboard, mouse, joystick and time";
    homepage = http://glfw.sourceforge.net/;
    license = licenses.zlib;
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = platforms.linux;
  };
}
