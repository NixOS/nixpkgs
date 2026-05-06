{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  wayland,
  wayland-protocols,
  wayland-scanner,
  libarchive,
  uthash,
  python3,
  python3Packages,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wl_shimeji-unwrapped";
  version = "0-unstable-2026-04-28";

  src = fetchFromGitHub {
    owner = "CluelessCatBurger";
    repo = "wl_shimeji";
    rev = "8ae15cf7e56325b08708e1b8d851baef679962d1";
    hash = "sha256-UBZXeuZJKGqbEK8Xwjs/Sk6JRktjBu4u6w5NGLjhuCs=";
    leaveDotGit = true;
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    pkg-config
    wayland
    wayland-protocols
    wayland-scanner
    libarchive
    uthash
    python3
  ];

  makeFlags = [
    "PREFIX=$(out)"
  ];

  preBuild = ''
    substituteInPlace ./Makefile \
    --replace-fail "\$(shell which python3)" "${lib.getExe' python3 "python3"}"
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Shimeji reimplementation for Wayland in C.";
    homepage = "https://github.com/CluelessCatBurger/wl_shimeji";
    mainProgram = "shimejictl";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ claymorwan ];
  };
})
