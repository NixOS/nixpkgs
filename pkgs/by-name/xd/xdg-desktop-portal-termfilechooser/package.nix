{
  stdenv,
  fetchFromGitHub,
  lib,
  xdg-desktop-portal,
  ninja,
  meson,
  pkg-config,
  inih,
  systemd,
  scdoc,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xdg-desktop-portal-termfilechooser";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "hunkyburrito";
    repo = "xdg-desktop-portal-termfilechooser";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IlPNNuQaGVW5QXcyA8cWiFJxwgXmviQoisDUWX9QP2s=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
  ];

  buildInputs = [
    xdg-desktop-portal
    inih
    systemd
  ];

  mesonFlags = [ "-Dsd-bus-provider=libsystemd" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "xdg-desktop-portal backend for choosing files with your favorite file chooser";
    homepage = "https://github.com/hunkyburrito/xdg-desktop-portal-termfilechooser";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with lib.maintainers; [
      body20002
      ltrump
    ];
    mainProgram = "xdg-desktop-portal-termfilechooser";
  };
})
