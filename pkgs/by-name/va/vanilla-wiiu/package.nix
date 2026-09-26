{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  networkmanager,
  libnl,
  openssl,
  git,
  SDL2,
  SDL2_ttf,
  SDL2_image,
  libwebp,
  libtiff,
  ffmpeg,
  polkit,
  libxml2,
  libx11,
  libGL,
  libdrm,
  gitUpdater,
  replaceVars,
}:
stdenv.mkDerivation {
  pname = "vanilla-wiiu";
  version = "0-unstable-2026-09-22";

  src = fetchFromGitHub {
    owner = "vanilla-wiiu";
    repo = "vanilla";
    rev = "786e70914ff5edcc6e989fcb237fb04f78eb3151";
    hash = "sha256-Di825OVklNKZ4kH4hZh/htKuWJrGjIDcLPOtJ33rvok=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    git
  ];

  buildInputs = [
    networkmanager
    libnl
    openssl
    SDL2
    SDL2_ttf
    SDL2_image
    libwebp
    libtiff
    ffmpeg
    polkit
    libxml2
    libx11
    libGL
    libdrm
  ];

  patches = [
    ./fix-sdl2-include.patch
    (replaceVars ./override-drc-hostap.patch {
      hostap = fetchFromGitHub {
        owner = "vanilla-wiiu";
        repo = "drc-hostap";
        rev = "a2f705daa143791180754100194c91714f7e8801";
        hash = "sha256-x99Nn7Gknx09vePQy1bKQPspPLBoUUeRJa1kLJQLkqk=";
      };
    })
  ];

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Software clone of the Wii U gamepad";
    homepage = "https://github.com/vanilla-wiiu/vanilla";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ headblockhead ];
    mainProgram = "vanilla";
    platforms = lib.platforms.linux;
  };
}
