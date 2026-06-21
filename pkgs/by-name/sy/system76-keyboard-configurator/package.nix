{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  gtk3,
  glib,
  wrapGAppsHook3,
  libusb1,
  hidapi,
  udev,
  pkg-config,
}:

# system76-keyboard-configurator tries to spawn a daemon as root via pkexec, so
# your system needs a PolicyKit authentication agent running for the
# configurator to work.

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "system76-keyboard-configurator";
  version = "1.3.13";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "keyboard-configurator";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Nb/N/tfyRucxRHyvlwET3O+JShyO/zxPg3+OuALFBpM=";
  };

  nativeBuildInputs = [
    pkg-config
    glib # for glib-compile-resources
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    hidapi
    libusb1
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    udev
  ];

  cargoHash = "sha256-Ws1LLX3K9/kpPJa6wureScSDswn1bIsu+s3C/VsDiEY=";

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm444 linux/com.system76.keyboardconfigurator.desktop -t $out/share/applications
    cp -r data/icons $out/share
  '';

  meta = {
    description = "Keyboard configuration application for System76 keyboards and laptops";
    mainProgram = "system76-keyboard-configurator";
    homepage = "https://github.com/pop-os/keyboard-configurator";
    license = with lib.licenses; [ gpl3Only ];
    maintainers = with lib.maintainers; [ mirrexagon ];
    platforms = with lib.platforms; linux ++ darwin;
  };
})
