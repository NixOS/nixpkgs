{ stdenv, lib, fetchFromGitHub, cmake, libGL, libXrandr, libXinerama, libXcursor, libX11
, darwin, fixDarwinDylibNames
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

  propagatedBuildInputs = [ libGL ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    libX11 libXrandr libXinerama libXcursor
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
