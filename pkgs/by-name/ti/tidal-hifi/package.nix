{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  callPackage,
  makeShellWrapper,
  copyDesktopItems,
  makeDesktopItem,
  stdenv,
  wrapGAppsHook3,
  glib,
  gtk3,
  gtk4,
  at-spi2-atk,
  libdrm,
  libgbm,
  libxkbcommon,
  libxshmfence,
  libGL,
  vulkan-loader,
  alsa-lib,
  cairo,
  cups,
  dbus,
  expat,
  gdk-pixbuf,
  nss,
  nspr,
  libX11,
  libxcb,
  libXcomposite,
  libXdamage,
  libXext,
  libXfixes,
  libXrandr,
  libxkbfile,
  pango,
  systemd,
  pciutils,
  libnotify,
  pipewire,
  libsecret,
  libpulseaudio,
  speechd-minimal,

  castlabs-electron ? callPackage ./electron.nix { },
}:

let
  version = "5.20.1";

  electronLibPath = lib.makeLibraryPath [
    alsa-lib
    at-spi2-atk
    cairo
    cups
    dbus
    expat
    gdk-pixbuf
    glib
    gtk3
    gtk4
    nss
    nspr
    libX11
    libxcb
    libXcomposite
    libXdamage
    libXext
    libXfixes
    libXrandr
    libxkbfile
    pango
    pciutils
    stdenv.cc.cc
    systemd
    libnotify
    pipewire
    libsecret
    libpulseaudio
    speechd-minimal
    libdrm
    libgbm
    libxkbcommon
    libxshmfence
    libGL
    vulkan-loader
  ];
in
buildNpmPackage (self: {
  pname = "tidal-hifi";
  inherit version;

  src = fetchFromGitHub {
    owner = "Mastermindzh";
    repo = "tidal-hifi";
    tag = version;
    hash = "sha256-uiRvbxUztLwNSB1BHa9rGrPl2akt21VqxEV4pBgNwPo=";
  };

  nativeBuildInputs = [
    makeShellWrapper
    wrapGAppsHook3
    copyDesktopItems
  ];

  npmDepsHash = "sha256-BsHlATxdZ/5QFr2HAGSeKo+aR7udfD6X8h/qyJnBrr0=";
  forceGitDeps = true;
  makeCacheWritable = true;

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  buildPhase = ''
    runHook preBuild

    npm run compile
    npm exec electron-builder -- \
        --dir \
        --config build/electron-builder.base.yml \
        -c.electronDist=${castlabs-electron.dist} \
        -c.electronVersion=${castlabs-electron.version}

    runHook postBuild
  '';

  desktopItems = [
    (makeDesktopItem {
      name = self.pname;
      desktopName = "TIDAL Hi-Fi";
      genericName = "Music Player";
      comment = self.meta.description;
      icon = "tidal-hifi";
      exec = self.meta.mainProgram;
      terminal = false;
      mimeTypes = [ "x-scheme-handler/tidal" ];
      categories = [
        "Audio"
        "Music"
        "Player"
        "Network"
        "AudioVideo"
      ];
      startupNotify = true;
      startupWMClass = "tidal-hifi";
      extraConfig.X-PulseAudio-Properties = "media.role=music";
    })
  ];

  dontWrapGApps = true;

  installPhase = ''
    runHook preInstall

    for i in 16 22 24 32 48 64 128 256 384; do
      install -Dm644 "assets/icons/$i"x"$i.png" "$out/share/icons/hicolor/$i"x"$i/apps/tidal-hifi.png"
    done

    mv dist/linux-unpacked "$out/share/tidal-hifi"

    runHook postInstall
  '';

  # see: pkgs/development/tools/electron/binary/generic.nix
  postFixup = ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${electronLibPath}:$out/share/tidal-hifi" \
      $out/share/tidal-hifi/tidal-hifi \
      $out/share/tidal-hifi/chrome_crashpad_handler

    # patch libANGLE
    patchelf \
      --set-rpath "${
        lib.makeLibraryPath [
          libGL
          pciutils
          vulkan-loader
        ]
      }" \
      $out/share/tidal-hifi/lib*GL*

    # replace bundled vulkan-loader
    ln -sf -t "$out/share/tidal-hifi" "${lib.getLib vulkan-loader}/lib/libvulkan.so.1"

    makeShellWrapper "$out/share/tidal-hifi/tidal-hifi" "$out/bin/tidal-hifi" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
      "''${gappsWrapperArgs[@]}"
  '';

  meta = {
    changelog = "https://github.com/Mastermindzh/tidal-hifi/releases/tag/${version}";
    description = "Web version of Tidal running in Electron with Hi-Fi support thanks to Widevine";
    homepage = "https://github.com/Mastermindzh/tidal-hifi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      gerg-l
      qbit
      spikespaz
    ];
    # `castlabs-electron` doesn't have a distribution for `aarch64-linux`.
    # See: <https://github.com/castlabs/electron-releases/issues/198>
    platforms = [ "x86_64-linux" ];
    mainProgram = "tidal-hifi";
  };
})
