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
  xorg,
  libGL,
  libdrm,
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
  version = "0-unstable-2026-01-02";

  src = fetchFromGitHub {
    owner = "vanilla-wiiu";
    repo = "vanilla";
    rev = "8e2f86712aba0e9020430dea9aea0a592375d380";
    hash = "sha256-1UQUii6WDS2K9GISKduk4qaTzwuVowPclWit7yZTm6k=";
  };

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
    xorg.libX11
    libGL
    libdrm
  ];

  patches = [ ./fix-sdl2-include.patch ];

  postPatch = ''
    substituteInPlace cmake/FindLibNL.cmake \
      --replace-fail /usr/include/libnl3 ${lib.getDev libnl}/include/libnl3
    substituteInPlace pipe/linux/CMakeLists.txt \
      --replace-fail "https://github.com/rolandoislas/drc-hostap.git" "${hostap}" \
      --replace-fail "--branch master" "--branch fetchgit"
  '';

  meta = {
    description = "A software clone of the Wii U gamepad for Linux";
    homepage = "https://github.com/vanilla-wiiu/vanilla";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ headblockhead ];
    mainProgram = "vanilla";
    platforms = lib.platforms.linux;
  };
}
