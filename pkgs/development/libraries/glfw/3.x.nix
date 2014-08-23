{ stdenv, fetchurl, cmake, mesa, libXrandr, libXi, libXxf86vm, libXfixes, x11 }:

stdenv.mkDerivation rec {
  name = "glfw-3.0.4";

  src = fetchurl {
    url = "mirror://sourceforge/glfw/${name}.tar.bz2";
    sha256 = "1h7g16ncgkl38w19x4dvnn17k9j0kqfvbb9whw9qc71lkq5xf2ag";
  };

  enableParallelBuilding = true;

  buildInputs = [ cmake mesa libXrandr libXi libXxf86vm libXfixes x11 ];

  meta = with stdenv.lib; { 
    description = "Multi-platform library for creating OpenGL contexts and managing input, including keyboard, mouse, joystick and time";
    homepage = "http://glfw.sourceforge.net/";
    license = licenses.zlib;
    maintainers = with maintainers; [ marcweber ];
    platforms = platforms.linux;
  };
}
