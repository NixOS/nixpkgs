{
  lib,
  fetchFromGitHub,
  nix-update-script,
  stdenv,
  wayland,
  wayland-protocols,
  wayland-scanner,
}:

stdenv.mkDerivation {
  pname = "wl-find-cursor";
  version = "0-unstable-2026-02-03";

  src = fetchFromGitHub {
    owner = "cjacker";
    repo = "wl-find-cursor";
    rev = "ce1a125702b466dc537c5490f7888b4a68dee883";
    hash = "sha256-IUreWEOWF1loS5SiAh8XPFrKE35Pxv6e8hhvdtNvjiU=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    wayland-scanner
  ];

  buildInputs = [
    wayland
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "/usr/share/wayland-protocols" "${wayland-protocols}/share/wayland-protocols" \
      --replace-fail "gcc" "${stdenv.cc.targetPrefix}cc" \
      --replace-fail "install: default" "install: all"
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Highlight and print the mouse cursor position on Wayland";
    homepage = "https://github.com/cjacker/wl-find-cursor";
    license = lib.licenses.mit;
    mainProgram = "wl-find-cursor";
    maintainers = with lib.maintainers; [ ilkecan ];
    platforms = lib.platforms.linux;
  };
}
