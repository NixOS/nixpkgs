args: with args;

stdenv.mkDerivation {
  name = "glefw-2.6";

  src = fetchurl {
    url = mirror://sourceforge/glfw/glfw-2.6.tar.bz2;
    sha256 = "1jnz7szax7410qrkiwkvq34sxy11w46ybyqbkaczdyvqas6cm1hv";
  };

  buildInputs = [mesa libX11 libXext];

  buildPhase = ''
    ensureDir $out
    make x11-install PREFIX=$out
  '';
  
  installPhase=":";

  meta = { 
    description = "multi-platform library for creating OpenGL contexts and managing input, including keyboard, mouse, joystick and time";
    homepage = http://glfw.sourceforge.net/;
    license = "zlib/libpng"; # http://www.opensource.org/licenses/zlib-license.php
    maintainers = [args.lib.maintainers.marcweber];
    platforms = args.lib.platforms.linux;
  };
}
