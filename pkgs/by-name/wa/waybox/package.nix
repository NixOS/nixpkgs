{ lib
, stdenv
, fetchFromGitHub
, cmake
, libGL
, libxkbcommon
, libxml2
, mesa
, meson
, ninja
, pixman
, pkg-config
, udev
, wayland
, wayland-protocols
, wayland-scanner
, wlroots
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "waybox";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "wizbright";
    repo = "waybox";
    rev = finalAttrs.version;
    hash = "sha256-G8dRa4hgev3x58uqp5To5OzF3zcPSuT3NL9MPnWf2M8=";
  };

  nativeBuildInputs = [
    cmake
    meson
    ninja
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    libGL
    libxkbcommon
    libxml2
    mesa # for libEGL
    pixman
    udev
    wayland
    wayland-protocols
    wlroots
  ];

  strictDeps = true;

  dontUseCmakeConfigure = true;

  passthru.providedSessions = [ "waybox" ];

  meta = {
    homepage = "https://github.com/wizbright/waybox";
    description = "An openbox clone on Wayland";
    license = lib.licenses.mit;
    mainProgram = "waybox";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    inherit (wayland.meta) platforms;
  };
})
