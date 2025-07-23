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
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-RRGE/gEWaSwvbytmtR5fLAke8QqIeuYJQzwC++Z1bgc=";
  };

  nativeBuildInputs = [
    cmake
    perl
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs =
    [
      lcms2
    ]
    ++ lib.optionals stdenv.isLinux [
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
    "-DCMAKE_BUILD_TYPE=Release"
    "-DTEV_DEPLOY=1"
  ];

  postInstall = lib.optionalString stdenv.isLinux ''
    wrapProgram $out/bin/tev \
      "''${gappsWrapperArgs[@]}" \
      --prefix PATH ":" "${zenity}/bin" \
      --prefix LD_LIBRARY_PATH ":" "${
        lib.makeLibraryPath [
          libxkbcommon
          wayland
        ]
      }"
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
