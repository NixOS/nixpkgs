{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  callPackage,
  libdbusmenu,
  xdg-utils,
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
  version = "5.19.0";

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
buildNpmPackage {
  pname = "tidal-hifi";
  inherit version;

  src = fetchFromGitHub {
    owner = "Mastermindzh";
    repo = "tidal-hifi";
    tag = version;
    hash = "sha256-/pPmfgKwrtOrEu7YVJTuQF/FIMa+W6uSnFbMFuyURFQ=";
  };

  nativeBuildInputs = [
    makeShellWrapper
    wrapGAppsHook3
    copyDesktopItems
  ];

  runtimeDependencies = [
    (lib.getLib systemd)
    libnotify
    libdbusmenu
    xdg-utils
  ];

  npmDepsHash = "sha256-TNhD/ZkqJtsidAEIOL/WmJZw09BuFgd4ECnzbieNhVY=";
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
      name = "TIDAL Hi-Fi";
      desktopName = "tidal-hifi";
      genericName = "TIDAL Hi-Fi";
      comment = "The web version of listen.tidal.com running in electron with hifi support thanks to widevine.";
      icon = "tidal-hifi";
      startupNotify = true;
      terminal = false;
      type = "Application";
      categories = [
        "Network"
        "Application"
        "AudioVideo"
        "Audio"
        "Video"
      ];
      startupWMClass = "tidal-hifi";
      mimeTypes = [ "x-scheme-handler/tidal" ];
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
    rm "$out/share/tidal-hifi/libvulkan.so.1"
    ln -s -t "$out/share/tidal-hifi" "${lib.getLib vulkan-loader}/lib/libvulkan.so.1"

    makeShellWrapper "$out/share/tidal-hifi/tidal-hifi" "$out/bin/tidal-hifi" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
      "''${gappsWrapperArgs[@]}"
  '';

  meta = {
    changelog = "https://github.com/Mastermindzh/tidal-hifi/releases/tag/${version}";
    description = "Web version of Tidal running in electron with hifi support thanks to widevine";
    homepage = "https://github.com/Mastermindzh/tidal-hifi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      gerg-l
      qbit
      spikespaz
    ];
    platforms = lib.platforms.linux;
    mainProgram = "tidal-hifi";
  };
}
