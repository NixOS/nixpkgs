{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  wayland-scanner,
  mpv-unwrapped,
  openssl,
  curl,
  libxkbcommon,
  dbus,
  libffi,
  wayland,
  egl-wayland,
  xorg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wiliwili";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "xfangfang";
    repo = "wiliwili";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-Fl8YV7yBW9dmcpcHCDVvkAzICTopNb4zKziDkR6NEwU=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ] ++ lib.optionals stdenv.isLinux [
    wayland-scanner
  ];

  buildInputs = [
    mpv-unwrapped
    openssl
    curl
    libxkbcommon
    dbus
  ] ++ lib.optionals stdenv.isLinux [
    libffi # needed for wayland
    wayland
    egl-wayland
    xorg.libX11
    xorg.libXrandr
    xorg.libXinerama
    xorg.libXcursor
    xorg.libXi
  ];

  cmakeFlags = [
    (lib.cmakeBool "PLATFORM_DESKTOP" true)
    (lib.cmakeBool "INSTALL" true)
    (lib.cmakeBool "GLFW_BUILD_WAYLAND" stdenv.isLinux)
    (lib.cmakeBool "GLFW_BUILD_X11" stdenv.isLinux)
    # Otherwise cpr cmake will try to download zlib
    (lib.cmakeBool "CPR_FORCE_USE_SYSTEM_CURL" true)
  ];

  meta = {
    description = "Third-party Bilibili client with a switch-like UI";
    homepage = "https://xfangfang.github.io/wiliwili";
    # https://github.com/xfangfang/wiliwili/discussions/355
    license = lib.licenses.gpl3Only;
    mainProgram = "wiliwili";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = with lib.platforms; unix ++ windows;
    # Testing on darwin was blocked due to broken swift
    # buildInputs should still need some tweaking, but can't be sure
    badPlatforms = lib.platforms.darwin;
  };
})
