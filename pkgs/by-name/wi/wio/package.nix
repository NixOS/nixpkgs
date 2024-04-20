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
  version = "unstable-2024-03-23";

  src = fetchFromGitHub {
    owner = "Rubo3";
    repo = "wio";
    rev = "a68fbaf0011610d55db0413ebb7aca6ff79a8dc3";
    hash = "sha256-iQulldgYuz++ank2rOL92Ydj6IOiBtNEVEEcVOlhkMk=";
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
