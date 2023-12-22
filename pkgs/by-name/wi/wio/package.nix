{ lib
, stdenv
, fetchFromGitHub
, alacritty
, cage
, cairo
, libxkbcommon
, makeWrapper
, mesa
, meson
, ninja
, pkg-config
, udev
, unstableGitUpdater
, wayland
, wayland-protocols
, wlroots
, xwayland
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wio";
  version = "unstable-2023-11-23";

  src = fetchFromGitHub {
    owner = "Rubo3";
    repo = "wio";
    rev = "77c33b555589068350078d634a256a8fbb7ffe6b";
    hash = "sha256-Wff8RPHfmgPYJ3cO0h5onHtWIvOYDqLjvF1O4uODuCY=";
  };

  nativeBuildInputs = [
    makeWrapper
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    cairo
    libxkbcommon
    mesa
    udev
    wayland
    wayland-protocols
    wlroots
    xwayland
  ];

  strictDeps = false; # why is it so hard?

  env.NIX_CFLAGS_COMPILE = "-Wno-error=maybe-uninitialized";

  postInstall = ''
    wrapProgram $out/bin/wio \
      --prefix PATH ":" "${lib.makeBinPath [ alacritty cage ]}"
  '';

  passthru = {
    providedSessions = [ "wio" ];
    updateScript = unstableGitUpdater { };
  };

  meta = {
    homepage = "https://github.com/Rubo3/wio";
    description = "Wayland compositor similar to Plan 9's rio";
    longDescription = ''
      Wio is a Wayland compositor for Linux and FreeBSD which has a similar look
      and feel to plan9's rio.
    '';
    license = with lib.licenses; [ bsd3 ];
    mainProgram = "wio";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    inherit (wayland.meta) platforms;
  };
})
