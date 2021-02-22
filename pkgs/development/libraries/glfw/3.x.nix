{ stdenv, lib, fetchFromGitHub, cmake
, libGL, libXrandr, libXinerama, libXcursor, libX11, libXi, libXext
, Cocoa, Kernel, fixDarwinDylibNames
}:

stdenv.mkDerivation rec {
  version = "3.3.2";
  pname = "glfw";

  src = fetchFromGitHub {
    owner = "glfw";
    repo = "GLFW";
    rev = version;
    sha256 = "0b5lsxz1xkzip7fvbicjkxvg5ig8gbhx1zrlhandqc0rpk56bvyw";
  };

  propagatedBuildInputs = [ libGL ];

  nativeBuildInputs = [ cmake ]
    ++ lib.optional stdenv.isDarwin fixDarwinDylibNames;

  buildInputs = [ libX11 libXrandr libXinerama libXcursor libXi libXext ]
    ++ lib.optionals stdenv.isDarwin [ Cocoa Kernel ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
  ] ++ lib.optional (!stdenv.isDarwin) [
    "-DCMAKE_C_FLAGS=-D_GLFW_GLX_LIBRARY='\"${lib.getLib libGL}/lib/libGL.so.1\"'"
  ];

  meta = with lib; {
    description = "Multi-platform library for creating OpenGL contexts and managing input, including keyboard, mouse, joystick and time";
    homepage = "https://www.glfw.org/";
    license = licenses.zlib;
    maintainers = with maintainers; [ marcweber twey ];
    platforms = platforms.unix;
  };
}
