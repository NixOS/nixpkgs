{
  lib,
  stdenv,
  fetchFromGitLab,
  alacritty,
  cage,
  cairo,
  libxkbcommon,
  makeWrapper,
  libgbm,
  meson,
  ninja,
  pkg-config,
  wayland-scanner,
  udev,
  unstableGitUpdater,
  wayland,
  wayland-protocols,
  wlroots,
  xwayland,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wio";
  version = "0.19.0";

  src = fetchFromGitLab {
    owner = "Rubo";
    repo = "wio";
    rev = finalAttrs.version;
    hash = "sha256-Ol9/dMYg1L+3jGFMpKsAPUAA7hkxu/v88JrI3v+ozAM=";
  };

  nativeBuildInputs = [
    makeWrapper
    meson
    ninja
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    cairo
    libxkbcommon
    libgbm
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
      --prefix PATH ":" "${
        lib.makeBinPath [
          alacritty
          cage
        ]
      }"
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
    maintainers = with lib.maintainers; [ ];
    inherit (wayland.meta) platforms;
  };
})
