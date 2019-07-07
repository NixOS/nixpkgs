{ stdenv, lib, fetchFromGitHub, cmake, libGL, libXrandr, libXinerama, libXcursor, libX11
, cf-private, Cocoa, Kernel, fixDarwinDylibNames
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
  ] ++ lib.optionals stdenv.isDarwin [
    Cocoa Kernel fixDarwinDylibNames
    # Needed for NSDefaultRunLoopMode symbols.
    cf-private
  ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=ON" ];

  preConfigure  = lib.optional (!stdenv.isDarwin) ''
    substituteInPlace src/glx_context.c --replace "libGL.so.1" "${lib.getLib libGL}/lib/libGL.so.1"
  '';

  meta = with stdenv.lib; {
    description = "Multi-platform library for creating OpenGL contexts and managing input, including keyboard, mouse, joystick and time";
    homepage = http://www.glfw.org/;
    license = licenses.zlib;
    maintainers = with maintainers; [ marcweber ];
    platforms = platforms.unix;
  };
}
