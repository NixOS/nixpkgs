{ stdenv, fetchFromGitHub, cmake, mesa, libXrandr, libXi, libXxf86vm, libXfixes, xlibsWrapper
, libXinerama, libXcursor
}:

stdenv.mkDerivation rec {
  version = "3.2.1";
  name = "glfw-${version}";

  src = fetchFromGitHub {
    owner = "glfw";
    repo = "GLFW";
    rev = "${version}";
    sha256 = "0gq6ad38b3azk0w2yy298yz2vmg2jmf9g0ydidqbmiswpk25ills";
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
