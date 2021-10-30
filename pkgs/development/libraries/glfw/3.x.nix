{ stdenv, lib, fetchFromGitHub, cmake
, libGL, libXrandr, libXinerama, libXcursor, libX11, libXi, libXext
, Cocoa, Kernel, fixDarwinDylibNames
, waylandSupport ? false, extra-cmake-modules, wayland
, wayland-protocols, libxkbcommon
}:

stdenv.mkDerivation rec {
  version = "3.3.4";
  pname = "glfw";

  src = fetchFromGitHub {
    owner = "glfw";
    repo = "GLFW";
    rev = version;
    sha256 = "sha256-BP4wxjgm0x0E68tNz5eudkVUyBnXkQlP7LY3ppZunhw=";
  };

  patches = lib.optional waylandSupport ./wayland.patch;

  propagatedBuildInputs = [ libGL ];

  nativeBuildInputs = [ cmake ]
    ++ lib.optional stdenv.isDarwin fixDarwinDylibNames
    ++ lib.optional waylandSupport extra-cmake-modules;

  buildInputs =
    if waylandSupport
    then [ wayland wayland-protocols libxkbcommon ]
    else [ libX11 libXrandr libXinerama libXcursor libXi libXext ]
         ++ lib.optionals stdenv.isDarwin [ Cocoa Kernel ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
  ] ++ lib.optionals (!stdenv.isDarwin) [
    "-DCMAKE_C_FLAGS=-D_GLFW_GLX_LIBRARY='\"${lib.getLib libGL}/lib/libGL.so.1\"'"
  ] ++ lib.optionals waylandSupport [
    "-DGLFW_USE_WAYLAND=ON"
    "-DCMAKE_C_FLAGS=-D_GLFW_EGL_LIBRARY='\"${lib.getLib libGL}/lib/libEGL.so.1\"'"
  ];

  postPatch = lib.optionalString waylandSupport ''
    substituteInPlace src/wl_init.c \
      --replace "libxkbcommon.so.0" "${lib.getLib libxkbcommon}/lib/libxkbcommon.so.0"
  '';

  meta = with lib; {
    description = "Multi-platform library for creating OpenGL contexts and managing input, including keyboard, mouse, joystick and time";
    homepage = "https://www.glfw.org/";
    license = licenses.zlib;
    maintainers = with maintainers; [ marcweber twey ];
    platforms = platforms.unix;
  };
}
