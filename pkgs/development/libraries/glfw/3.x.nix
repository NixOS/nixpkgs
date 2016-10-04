{ stdenv, fetchFromGitHub, cmake, mesa, libXrandr, libXi, libXxf86vm, libXfixes, xlibsWrapper
, libXinerama, libXcursor
}:

stdenv.mkDerivation rec {
  version = "3.2";
  name = "glfw-${version}";

  src = fetchFromGitHub {
    owner = "glfw";
    repo = "GLFW";
    rev = "${version}";
    sha256 = "0knqf40jij2z1mia091xqyky5r11r4qyh7b8172blrmgm9q23sl9";
  };

  enableParallelBuilding = true;

  buildInputs = [
    cmake mesa libXrandr libXi libXxf86vm libXfixes xlibsWrapper
    libXinerama libXcursor
  ];

  cmakeFlags = "-DBUILD_SHARED_LIBS=ON";

  meta = with stdenv.lib; { 
    description = "Multi-platform library for creating OpenGL contexts and managing input, including keyboard, mouse, joystick and time";
    homepage = "http://www.glfw.org/";
    license = licenses.zlib;
    maintainers = with maintainers; [ marcweber ];
    platforms = platforms.linux;
  };
}
