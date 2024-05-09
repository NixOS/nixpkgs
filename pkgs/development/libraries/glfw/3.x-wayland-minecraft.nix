{ stdenv, lib, fetchFromGitHub, fetchpatch2, cmake, extra-cmake-modules
, libGL, wayland, wayland-protocols, libxkbcommon, libdecor
}:

stdenv.mkDerivation {
  version = "unstable-2023-06-01";
  pname = "glfw-wayland-minecraft";

  src = fetchFromGitHub {
    owner = "glfw";
    repo = "GLFW";
    rev = "3eaf1255b29fdf5c2895856c7be7d7185ef2b241";
    sha256 = "sha256-UnwuE/3q6I4dS5syagpnqrDEVDK9XSVdyOg7KNkdUUA=";
  };

  patches = [
    (fetchpatch2 {
      url = "https://raw.githubusercontent.com/Admicos/minecraft-wayland/15f88a515c63a9716cfdf4090fab8e16543f4ebd/0003-Don-t-crash-on-calls-to-focus-or-icon.patch";
      hash = "sha256-NZbKh16h+tWXXnz13QcFBFaeGXMNxZKGQb9xJEahFnE=";
    })
    (fetchpatch2 {
      url = "https://raw.githubusercontent.com/Admicos/minecraft-wayland/15f88a515c63a9716cfdf4090fab8e16543f4ebd/0005-Add-warning-about-being-an-unofficial-patch.patch";
      hash = "sha256-QMUNlnlCeFz5gIVdbM+YXPsrmiOl9cMwuVRSOvlw+T0=";
    })
  ];

  propagatedBuildInputs = [ libGL ];

  nativeBuildInputs = [ cmake extra-cmake-modules ];

  buildInputs = [ wayland wayland-protocols libxkbcommon ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DGLFW_BUILD_WAYLAND=ON"
    "-DGLFW_BUILD_X11=OFF"
    "-DCMAKE_C_FLAGS=-D_GLFW_EGL_LIBRARY='\"${lib.getLib libGL}/lib/libEGL.so.1\"'"
  ];

  postPatch = ''
    substituteInPlace src/wl_init.c \
      --replace "libxkbcommon.so.0" "${lib.getLib libxkbcommon}/lib/libxkbcommon.so.0"

    substituteInPlace src/wl_init.c \
      --replace "libdecor-0.so.0" "${lib.getLib libdecor}/lib/libdecor-0.so.0"

    substituteInPlace src/wl_init.c \
      --replace "libwayland-client.so.0" "${lib.getLib wayland}/lib/libwayland-client.so.0"

    substituteInPlace src/wl_init.c \
      --replace "libwayland-cursor.so.0" "${lib.getLib wayland}/lib/libwayland-cursor.so.0"

    substituteInPlace src/wl_init.c \
      --replace "libwayland-egl.so.1" "${lib.getLib wayland}/lib/libwayland-egl.so.1"
  '';

  meta = with lib; {
    description = "Multi-platform library for creating OpenGL contexts and managing input, including keyboard, mouse, joystick and time - with patches to support Minecraft on Wayland";
    homepage = "https://www.glfw.org/";
    license = licenses.zlib;
    maintainers = with maintainers; [ Scrumplex ];
    platforms = platforms.linux;
  };
}
