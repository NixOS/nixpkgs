{ stdenv, lib, fetchFromGitHub, cmake, mesa_noglu, libXrandr, libXinerama, libXcursor, libX11, libXext, libXi
, darwin, fixDarwinDylibNames
}:

stdenv.mkDerivation rec {
  version = "0d4534733b7a748a21a1b1177bb37a9b224e3582";
  name = "glfw-${version}";

  src = fetchFromGitHub {
    owner = "glfw";
    repo = "GLFW";
    rev = "${version}";
    sha256 = "12dhfvphhy7gx1n6jsdqsklkda2493csmrssx69wm0z8zwpp67q4";
  };

  enableParallelBuilding = true;

  propagatedBuildInputs = [ mesa_noglu ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    libX11 libXrandr libXinerama libXcursor libXext libXi
  ] ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [ Cocoa Kernel fixDarwinDylibNames ]);

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=ON" ];

  meta = with stdenv.lib; {
    description = "Multi-platform library for creating OpenGL contexts and managing input, including keyboard, mouse, joystick and time";
    homepage = http://www.glfw.org/;
    license = licenses.zlib;
    maintainers = with maintainers; [ marcweber ];
    platforms = platforms.unix;
  };
}
