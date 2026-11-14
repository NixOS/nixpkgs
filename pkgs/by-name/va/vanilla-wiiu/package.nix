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
  unstableGitUpdater,
  replaceVars,
}:
stdenv.mkDerivation {
  pname = "vanilla-wiiu";
  version = "0-unstable-2026-11-05";

  src = fetchFromGitHub {
    owner = "vanilla-wiiu";
    repo = "vanilla";
    rev = "2e796b45df5ff2744caad813d7149096c7588f20";
    hash = "sha256-QflNiUcJ7yAHmu9X4NZYvNYj209t21Ky5SIC/Y4kXvA=";
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

  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };

  meta = {
    description = "Software clone of the Wii U gamepad";
    homepage = "https://github.com/vanilla-wiiu/vanilla";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ headblockhead ];
    mainProgram = "vanilla";
    platforms = lib.platforms.linux;
  };
}
