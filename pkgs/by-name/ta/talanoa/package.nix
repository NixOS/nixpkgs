{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeWrapper,
  wrapGAppsHook3,
  nix-update-script,
  alsa-lib,
  at-spi2-core,
  cairo,
  cups,
  dbus,
  expat,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  gtk3,
  libdrm,
  libgbm,
  libgcc,
  libGL,
  libnotify,
  libx11,
  libxcb,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxkbcommon,
  libxrandr,
  libxscrnsaver,
  libxshmfence,
  libxtst,
  nspr,
  nss,
  pango,
  systemd,
  vulkan-loader,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "talanoa";
  version = "1.2.2";

  src = fetchurl {
    url = "https://github.com/talanoa-email/desktop-releases/releases/download/v${finalAttrs.version}/talanoa_${finalAttrs.version}_amd64.deb";
    hash = "sha256-CVoBZR1jP1oHlMFvFpOHxEpSNHeQ/9Ebks3cG7dUPW0=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
    wrapGAppsHook3
  ];

  buildInputs = [
    alsa-lib
    at-spi2-core
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk3
    libdrm
    libgbm
    libgcc
    libGL
    libnotify
    libx11
    libxcb
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxkbcommon
    libxrandr
    libxscrnsaver
    libxshmfence
    libxtst
    nspr
    nss
    pango
    (lib.getLib stdenv.cc.cc)
    systemd
    vulkan-loader
  ];

  # Loaded with dlopen at run time, invisible to autoPatchelf otherwise.
  runtimeDependencies = [
    libGL
    libnotify
    (lib.getLib systemd)
    vulkan-loader
  ];

  dontConfigure = true;
  dontBuild = true;
  # The binary is wrapped once, in preFixup, with the GApps args.
  dontWrapGApps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp -r usr/lib/talanoa $out/lib/
    # A setuid helper cannot work from the store; Chromium uses user namespaces instead.
    rm $out/lib/talanoa/chrome-sandbox

    install -Dm644 usr/share/applications/talanoa.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/talanoa.desktop \
      --replace-fail "Categories=GNOME;GTK;Utility;" "Categories=Network;Email;"
    sed -i -e '/^GenericName=/d' -e '/^\[Desktop Entry\]/a GenericName=Email Client' \
      $out/share/applications/talanoa.desktop

    install -Dm644 usr/share/pixmaps/talanoa.png $out/share/icons/hicolor/1024x1024/apps/talanoa.png

    runHook postInstall
  '';

  preFixup = ''
    makeWrapper $out/lib/talanoa/Talanoa $out/bin/talanoa \
      "''${gappsWrapperArgs[@]}" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Email client that feels like a messenger";
    longDescription = ''
      Talanoa turns email into conversations you read like a chat, with a to-do
      board, a calendar and an AI assistant that runs on your computer. Mail is
      stored locally, with no cloud sync. It connects to Gmail, Outlook, Yahoo,
      iCloud and any IMAP account.
    '';
    homepage = "https://talanoa.email";
    downloadPage = "https://talanoa.email/download";
    changelog = "https://talanoa.email/changelog";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [ BetterCallJohn ];
    mainProgram = "talanoa";
    platforms = [ "x86_64-linux" ];
  };
})
