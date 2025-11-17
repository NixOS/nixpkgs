{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  vala,
  pkg-config,
  gettext,
  ninja,
  alsa-lib,
  xfce4-panel,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xfce4-alsa-plugin";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "equeim";
    repo = "xfce4-alsa-plugin";
    tag = finalAttrs.version;
    hash = "sha256-95uVHDyXji8dut7qfE5V/uBBt6DPYF/YfudHe7HJcE8=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    meson
    vala
    pkg-config
    gettext
    ninja
  ];

  buildInputs = [
    alsa-lib
    xfce4-panel
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/equeim/xfce4-alsa-plugin";
    description = "Simple ALSA volume control for xfce4-panel";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ProxyVT ];
    teams = [ lib.teams.xfce ];
  };
})
