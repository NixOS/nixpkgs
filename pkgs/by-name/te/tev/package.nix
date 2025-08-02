{
  lib,
  stdenv,
  cmake,
  darwin,
  fetchFromGitHub,
  lcms2,
  libGL,
  libffi,
  libxkbcommon,
  perl,
  pkg-config,
  wayland,
  wayland-protocols,
  wayland-scanner,
  wrapGAppsHook3,
  xorg,
  zenity,
}:

stdenv.mkDerivation rec {
  pname = "tev";
  version = "2.3.2";

  src = fetchFromGitHub {
    owner = "Tom94";
    repo = "tev";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-RRGE/gEWaSwvbytmtR5fLAke8QqIeuYJQzwC++Z1bgc=";
  };

  postPatch = lib.optionalString stdenv.hostPlatform.isLinux (
    let
      waylandLibPath = lib.makeLibraryPath [ wayland ];
    in
    ''
      substituteInPlace ./dependencies/nanogui/ext/glfw/src/wl_init.c \
        --replace-fail "libwayland-client.so" "${waylandLibPath}/libwayland-client.so" \
        --replace-fail "libwayland-cursor.so" "${waylandLibPath}/libwayland-cursor.so" \
        --replace-fail "libwayland-egl.so" "${waylandLibPath}/libwayland-egl.so" \
        --replace-fail "libxkbcommon.so" "${lib.makeLibraryPath [ libxkbcommon ]}/libxkbcommon.so"
    ''
  );

  nativeBuildInputs = [
    cmake
    perl
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    lcms2
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libffi
    libxkbcommon
    wayland
    wayland-protocols
    wayland-scanner
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
    xorg.libXinerama
    xorg.libXrandr
  ];

  dontWrapGApps = true; # We also need zenity (see below)

  cmakeFlags = [
    "-DTEV_DEPLOY=1"
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    wrapProgram $out/bin/tev \
      "''${gappsWrapperArgs[@]}" \
      --prefix PATH ":" "${zenity}/bin"
  '';

  env.CXXFLAGS = "-include cstdint";

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
