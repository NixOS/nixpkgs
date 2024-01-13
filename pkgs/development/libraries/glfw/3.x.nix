{ stdenv, lib, fetchFromGitHub, cmake
, libGL, libXrandr, libXinerama, libXcursor, libX11, libXi, libXext
, Carbon, Cocoa, Kernel, OpenGL, fixDarwinDylibNames
, waylandSupport ? false, extra-cmake-modules, wayland
, wayland-protocols, libxkbcommon
}:

stdenv.mkDerivation rec {
  version = "3.3.8";
  pname = "glfw";

  src = fetchFromGitHub {
    owner = "glfw";
    repo = "GLFW";
    rev = version;
    sha256 = "sha256-4+H0IXjAwbL5mAWfsIVhW0BSJhcWjkQx4j2TrzZ3aIo=";
  };

  # Fix linkage issues on X11 (https://github.com/NixOS/nixpkgs/issues/142583)
  patches = lib.optional (!waylandSupport) ./x11.patch;

  propagatedBuildInputs =
    lib.optionals stdenv.isDarwin [ OpenGL ]
    ++ lib.optionals stdenv.isLinux [ libGL ];

  nativeBuildInputs = [ cmake ]
    ++ lib.optional stdenv.isDarwin fixDarwinDylibNames
    ++ lib.optional waylandSupport extra-cmake-modules;

  buildInputs =
    lib.optionals stdenv.isDarwin [ Carbon Cocoa Kernel ]
    ++ lib.optionals (stdenv.isLinux && waylandSupport) [ wayland wayland-protocols libxkbcommon ]
    ++ lib.optionals (stdenv.isLinux && !waylandSupport) [ libX11 libXrandr libXinerama libXcursor libXi libXext ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
  ] ++ lib.optionals (!stdenv.isDarwin && !stdenv.hostPlatform.isWindows) [
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
    platforms = platforms.unix ++ platforms.windows;
  };
}
