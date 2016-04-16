{ stdenv, fetchFromGitHub, cmake, mesa, libXrandr, libXi, libXxf86vm, libXfixes, xlibsWrapper
, libXinerama, libXcursor
}:

stdenv.mkDerivation rec {
  version = "3.1.2";
  name = "glfw-${version}";

  src = fetchFromGitHub {
    owner = "glfw";
    repo = "GLFW";
    rev = "${version}";
    sha256 = "1aj1dfyyd0170gpz32j2xlqbvbsxwbg028xiqai3mqc44xfp10kw";
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
