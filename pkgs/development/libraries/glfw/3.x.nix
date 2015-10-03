{ stdenv, fetchurl, cmake, mesa, libXrandr, libXi, libXxf86vm, libXfixes, xlibsWrapper
, libXinerama, libXcursor
}:

stdenv.mkDerivation rec {
  name = "glfw-3.1.1";

  src = fetchurl {
    url = "mirror://sourceforge/glfw/${name}.tar.bz2";
    sha256 = "0q9dhbj2az7jwwi556zai0qr8zmg6d2lyxcqngppkw0x7hi1d1aa";
  };

  enableParallelBuilding = true;

  buildInputs = [
    cmake mesa libXrandr libXi libXxf86vm libXfixes xlibsWrapper
    libXinerama libXcursor
  ];

  cmakeFlags = "-DBUILD_SHARED_LIBS=ON";

  meta = with stdenv.lib; { 
    description = "Multi-platform library for creating OpenGL contexts and managing input, including keyboard, mouse, joystick and time";
    homepage = "http://glfw.sourceforge.net/";
    license = licenses.zlib;
    maintainers = with maintainers; [ marcweber ];
    platforms = platforms.linux;
  };
}
