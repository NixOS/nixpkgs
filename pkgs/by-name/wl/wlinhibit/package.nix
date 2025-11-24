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
stdenv.mkDerivation {
  pname = "wlinhibit";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "0x5a4";
    repo = "wlinhibit";
    rev = "v0.1.2";
    hash = "sha256-mAEBnlIfW1R5+3CMH4ZumQ39Ss2K7PfW28I4/O9saWE=";
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
    description = "Simple, stupid idle inhibitor for wayland";
    license = lib.licenses.mit;
    homepage = "https://github.com/0x5a4/wlinhibit";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ _0x5a4 ];
  };
}
