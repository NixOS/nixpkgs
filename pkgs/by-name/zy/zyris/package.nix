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
  # Build from the Lite release asset: the same program with no speech engine
  # and no window, driven from the tray. Exposed as `zyris-lite`.
  withLite ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = if withLite then "zyris-lite" else "zyris";
  version = "0.3.0";

  strictDeps = true;
  __structuredAttrs = true;

  # The upstream build downloads ONNX Runtime at build time, so the released .deb is repackaged.
  src = fetchurl {
    url = "https://github.com/attacca-cc/zyris/releases/download/v${finalAttrs.version}/${
      if withLite then "Zyris-Lite" else "Zyris"
    }_${finalAttrs.version}_amd64.deb";
    hash =
      if withLite then
        "sha256-j+9scjMJEdfRoPPev8r4YIc7LJeM0Rt4lvQsdRS5Tbk="
      else
        "sha256-EUQcfdVaknBRTofNdmsdsr72UNZbdI8KH+P6LmZ9WP4=";
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
    description =
      if withLite then
        "Desktop node for Attacca that lets an agent use this computer, with no speech and no window"
      else
        "Desktop node for Attacca that lets an agent talk with you and use this computer";
    longDescription = ''
      Zyris keeps a computer connected to the user's agent. The ordinary build
      has a voice/typed conversation window; the Lite build leaves out the
      speech engine and the window and runs from the tray.
    '';
    homepage = "https://github.com/attacca-cc/zyris";
    changelog = "https://github.com/attacca-cc/zyris/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ridanit-ruma ];
    mainProgram = "zyris";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
