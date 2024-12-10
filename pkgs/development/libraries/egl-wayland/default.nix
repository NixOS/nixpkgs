{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  eglexternalplatform,
  pkg-config,
  meson,
  ninja,
  wayland-scanner,
  libGL,
  libX11,
  libdrm,
  wayland,
  wayland-protocols,
}:

stdenv.mkDerivation rec {
  pname = "egl-wayland";
  version = "1.1.13";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "Nvidia";
    repo = pname;
    rev = version;
    hash = "sha256-NA+jr27aYu0XPG9sxnBtjeBTFHmV7TENRsFy8dDdNUc=";
  };

  postPatch = ''
    # Declares an includedir but doesn't install any headers
    # CMake's `pkg_check_modules(NAME wayland-eglstream IMPORTED_TARGET)` considers this an error
    sed -i -e '/includedir/d' wayland-eglstream.pc.in
  '';

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    libGL
    libX11
    libdrm
    wayland
    wayland-protocols
  ];

  propagatedBuildInputs = [
    eglexternalplatform
  ];

  meta = with lib; {
    description = "The EGLStream-based Wayland external platform";
    homepage = "https://github.com/NVIDIA/egl-wayland/";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ hedning ];
  };
}
