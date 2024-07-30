{ stdenv, lib, fetchFromGitHub, cmake
, libGL, libXrandr, libXinerama, libXcursor, libX11, libXi, libXext
, Carbon, Cocoa, Kernel, fixDarwinDylibNames
, extra-cmake-modules, wayland
, wayland-scanner, wayland-protocols, libxkbcommon, libdecor
}:

stdenv.mkDerivation rec {
  version = "3.4";
  pname = "glfw";

  src = fetchFromGitHub {
    owner = "glfw";
    repo = "GLFW";
    rev = version;
    sha256 = "sha256-FcnQPDeNHgov1Z07gjFze0VMz2diOrpbKZCsI96ngz0=";
  };

  # Fix linkage issues on X11 (https://github.com/NixOS/nixpkgs/issues/142583)
  patches = ./x11.patch;

  propagatedBuildInputs = [ libGL ];

  nativeBuildInputs = [ cmake extra-cmake-modules ]
    ++ lib.optional stdenv.isDarwin fixDarwinDylibNames
    ++ lib.optionals stdenv.isLinux [ wayland-scanner ];

  buildInputs =
    lib.optionals stdenv.isDarwin [ Carbon Cocoa Kernel ]
    ++ lib.optionals stdenv.isLinux [
      wayland
      wayland-protocols
      libxkbcommon
      libX11
      libXrandr
      libXinerama
      libXcursor
      libXi
      libXext
    ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
  ] ++ lib.optionals (!stdenv.isDarwin && !stdenv.hostPlatform.isWindows) [
    "-DCMAKE_C_FLAGS=-D_GLFW_GLX_LIBRARY='\"${lib.getLib libGL}/lib/libGL.so.1\"'"
    "-DCMAKE_C_FLAGS=-D_GLFW_EGL_LIBRARY='\"${lib.getLib libGL}/lib/libEGL.so.1\"'"
  ];

  postPatch = lib.optionalString stdenv.isLinux ''
    substituteInPlace src/wl_init.c \
      --replace-fail "libxkbcommon.so.0" "${lib.getLib libxkbcommon}/lib/libxkbcommon.so.0" \
      --replace-fail "libdecor-0.so.0" "${lib.getLib libdecor}/lib/libdecor-0.so.0" \
      --replace-fail "libwayland-client.so.0" "${lib.getLib wayland}/lib/libwayland-client.so.0" \
      --replace-fail "libwayland-cursor.so.0" "${lib.getLib wayland}/lib/libwayland-cursor.so.0" \
      --replace-fail "libwayland-egl.so.1" "${lib.getLib wayland}/lib/libwayland-egl.so.1"
  '';

  # glfw may dlopen libwayland-client.so:
  postFixup = lib.optionalString stdenv.isLinux ''
    patchelf ''${!outputLib}/lib/libglfw.so --add-rpath ${lib.getLib wayland}/lib
  '';

  meta = with lib; {
    description = "Multi-platform library for creating OpenGL contexts and managing input, including keyboard, mouse, joystick and time";
    homepage = "https://www.glfw.org/";
    license = licenses.zlib;
    maintainers = with maintainers; [ marcweber twey ];
    platforms = platforms.unix ++ platforms.windows;
  };
}
