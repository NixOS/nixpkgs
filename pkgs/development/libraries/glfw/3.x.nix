{ stdenv, lib, fetchFromGitHub, cmake
, libGL, libXrandr, libXinerama, libXcursor, libX11, libXi, libXext
, Cocoa, Kernel, fixDarwinDylibNames
}:

stdenv.mkDerivation rec {
  version = "3.3.1";
  pname = "glfw";

  src = fetchFromGitHub {
    owner = "glfw";
    repo = "GLFW";
    rev = version;
    sha256 = "0c7nlrhq84gdq10diyv6nshjbv8410bmn0vging815pfvis208xc";
  };

  enableParallelBuilding = true;

  propagatedBuildInputs = [ libGL ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [ libX11 libXrandr libXinerama libXcursor libXi libXext ]
    ++ lib.optionals stdenv.isDarwin [ Cocoa Kernel fixDarwinDylibNames ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=ON" ];

  preConfigure  = lib.optional (!stdenv.isDarwin) ''
    substituteInPlace src/glx_context.c --replace "libGL.so.1" "${lib.getLib libGL}/lib/libGL.so.1"
  '';

  meta = with stdenv.lib; {
    description = "Multi-platform library for creating OpenGL contexts and managing input, including keyboard, mouse, joystick and time";
    homepage = https://www.glfw.org/;
    license = licenses.zlib;
    maintainers = with maintainers; [ marcweber twey ];
    platforms = platforms.unix;
  };
}
