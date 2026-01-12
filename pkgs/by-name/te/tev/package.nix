{
  lib,
  stdenv,
  cmake,
  darwin,
  dbus,
  fetchFromGitHub,
  lcms2,
  libGL,
  libffi,
  libxkbcommon,
  nasm,
  perl,
  pkg-config,
  wayland,
  wayland-protocols,
  wayland-scanner,
  libxrandr,
  libxi,
  libxinerama,
  libxcursor,
  libx11,
}:

stdenv.mkDerivation rec {
  pname = "tev";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "Tom94";
    repo = "tev";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-R7nzzYP7yA7bYQ6WLRrxNoEe7p7ElvQIJCNBu8zICfM=";
  };

  postPatch = lib.optionalString stdenv.hostPlatform.isLinux (
    let
      waylandLibPath = "${lib.getLib wayland}/lib";
    in
    ''
      substituteInPlace ./dependencies/nanogui/ext/glfw/src/wl_init.c \
        --replace-fail "libwayland-client.so" "${waylandLibPath}/libwayland-client.so" \
        --replace-fail "libwayland-cursor.so" "${waylandLibPath}/libwayland-cursor.so" \
        --replace-fail "libwayland-egl.so" "${waylandLibPath}/libwayland-egl.so" \
        --replace-fail "libxkbcommon.so" "${lib.getLib libxkbcommon}/lib/libxkbcommon.so"
    ''
  );

  nativeBuildInputs = [
    cmake
    nasm
    perl
    pkg-config
  ];

  buildInputs = [
    lcms2
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    dbus
    libffi
    libGL
    libxkbcommon
    wayland
    wayland-protocols
    wayland-scanner
    libx11
    libxcursor
    libxi
    libxinerama
    libxrandr
  ];

  cmakeFlags = [
    "-DTEV_DEPLOY=1"
  ];

  meta = {
    description = "High dynamic range (HDR) image viewer for people who care about colors";
    mainProgram = "tev";
    longDescription = ''
      High dynamic range (HDR) image viewer for people who care about colors. It is
      - Lightning fast: starts up instantly, loads hundreds of images in seconds.
      - Accurate: understands color profiles and displays HDR.
      - Versatile: supports many formats, histograms, pixel peeping, tonemaps, etc.
    '';
    changelog = "https://github.com/Tom94/tev/releases/tag/v${version}";
    homepage = "https://github.com/Tom94/tev";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ tom94 ];
    platforms = lib.platforms.unix;
  };
}
