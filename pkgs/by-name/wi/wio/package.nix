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
  version = "0.17.3-unstable-2024-04-30";

  src = fetchFromGitHub {
    owner = "Rubo3";
    repo = "wio";
    rev = "9d459df379efdcf20ea10906c48c79c506c32066";
    hash = "sha256-Bn7mCVQPH/kH2WRsGPPGIGgvk0r894zZHCHl6BVmWVg=";
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
