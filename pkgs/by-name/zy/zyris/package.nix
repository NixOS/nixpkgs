{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  wrapGAppsHook3,
  webkitgtk_4_1,
  gtk3,
  libsoup_3,
  glib,
  glib-networking,
  cairo,
  pango,
  gdk-pixbuf,
  atk,
  harfbuzz,
  openssl,
  alsa-lib,
  pipewire,
  libgbm,
  libayatana-appindicator,
  libxkbcommon,
  dbus,
  libxcb,
  libx11,
  wayland,
  libGL,
  vulkan-loader,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zyris";
  version = "0.2.1";

  strictDeps = true;
  __structuredAttrs = true;

  # The upstream build downloads ONNX Runtime at build time, so the released .deb is repackaged.
  src = fetchurl {
    url = "https://github.com/attacca-cc/zyris/releases/download/v${finalAttrs.version}/Zyris_${finalAttrs.version}_amd64.deb";
    hash = "sha256-g9xY4+0baiIN4vu+PP+ajEs9/bw0AzPdIU2/KYincmE=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    wrapGAppsHook3
  ];

  buildInputs = [
    webkitgtk_4_1
    gtk3
    libsoup_3
    glib
    glib-networking
    cairo
    pango
    gdk-pixbuf
    atk
    harfbuzz
    openssl
    alsa-lib
    pipewire
    libgbm
    libxkbcommon
    dbus
    libxcb
    libx11
    wayland
    vulkan-loader
  ];

  # dlopen'd: the tray icon and the GPU backends.
  runtimeDependencies = [
    libayatana-appindicator
    libGL
    vulkan-loader
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r usr/* $out/
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Desktop node for Attacca that lets an agent talk with you and use this computer";
    homepage = "https://github.com/attacca-cc/zyris";
    changelog = "https://github.com/attacca-cc/zyris/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ridanit-ruma ];
    mainProgram = "zyris";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
