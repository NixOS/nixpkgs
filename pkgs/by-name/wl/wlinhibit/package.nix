{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  wayland,
  wayland-protocols,
  wayland-scanner,
}:
stdenv.mkDerivation rec {
  pname = "wlinhibit";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "0x5a4";
    repo = "wlinhibit";
    rev = "v0.1.1";
    hash = "sha256-YQHJ9sLHSV8GJP7IpRzmtDbeB86y/a48mLcYy4iDciw=";
  };

  buildInputs = [
    wayland
    wayland-protocols
  ];

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
  ];

  meta = {
    description = "simple, stupid idle inhibitor for wayland";
    license = lib.licenses.mit;
    homepage = "https://github.com/0x5a4/wlinhibit";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [_0x5a4];
  };
}
