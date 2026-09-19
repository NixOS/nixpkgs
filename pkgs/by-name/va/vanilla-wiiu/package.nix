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
}:
let
  hostap = fetchFromGitHub {
    owner = "rolandoislas";
    repo = "drc-hostap";
    rev = "418e5e206786de2482864a0ec3a59742a33b6623";
    hash = "sha256-kAv/PetD6Ia5NzmYMWWyWQll1P+N2bL/zaV9ATiGVV0=";
    leaveDotGit = true;
  };
in
stdenv.mkDerivation {
  pname = "vanilla-wiiu";
  version = "0-unstable-2026-08-02";

  src = fetchFromGitHub {
    owner = "vanilla-wiiu";
    repo = "vanilla";
    rev = "c008b9baf35074a7e340b79f4a51d0aad76ef243";
    hash = "sha256-wjRhR/hZXOIajMFAjBr5PqFy8zwBa/paMBuV+vhhh90=";
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

  patches = [ ./fix-sdl2-include.patch ];

  postPatch = ''
    substituteInPlace pipe/linux/CMakeLists.txt \
      --replace-fail "https://github.com/rolandoislas/drc-hostap.git" "${hostap}" \
      --replace-fail "--branch master" "--branch fetchgit"
  '';

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
