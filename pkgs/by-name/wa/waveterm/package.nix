{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  buildNpmPackage,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  electron,
  pkg-config,
  nix-update-script,
}:

let
  pname = "waveterm";
  version = "0.14.5";

  src = fetchFromGitHub {
    owner = "wavetermdev";
    repo = "waveterm";
    rev = "v${version}";
    hash = "sha256-SUcvIpM+++qfyAlwUPSGVz2OUJXPe0bsefcjUKYUF/g=";
  };

  archSuffix =
    {
      x86_64 = "x64";
      aarch64 = "arm64";
    }
    .${stdenv.hostPlatform.parsed.cpu.name};

  wavesrv = buildGoModule {
    pname = "${pname}-srv";
    inherit version src;

    vendorHash = "sha256-EyDS/AB56+yE54XhwnQhalNPZwMM/Hp2kWQN824yq0k=";

    subPackages = [
      "cmd/server"
      "cmd/wsh"
    ];

    tags = [
      "osusergo"
      "sqlite_omit_load_extension"
    ];

    ldflags = [
      "-s"
      "-w"
      "-X main.WaveVersion=${version}"
      "-X main.BuildTime=197001010000"
    ];

    postInstall = ''
      mv $out/bin/server $out/bin/wavesrv.${archSuffix}
      ln -s $out/bin/wavesrv.${archSuffix} $out/bin/wavesrv

      mv $out/bin/wsh $out/bin/wsh-${version}-linux.${archSuffix}
      ln -s $out/bin/wsh-${version}-linux.${archSuffix} $out/bin/wsh
    '';

    nativeBuildInputs = [ pkg-config ];
  };

in
buildNpmPackage {
  inherit pname version src;

  strictDeps = true;
  __structuredAttrs = true;

  npmDepsHash = "sha256-YkRfTZwjIet6CWTtqG8X9LjoCOjHO+L2uHHtBlr7tao=";

  npmFlags = [ "--ignore-scripts" ];

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  postPatch = ''
    substituteInPlace emain/emain-platform.ts \
      --replace-fail 'const isDev = !app.isPackaged;' 'const isDev = false;' \
      --replace-fail 'return process.resourcesPath;' 'return getElectronAppBasePath();'
  '';

  buildPhase = ''
    runHook preBuild

    if [ -d schema ]; then
      mkdir -p dist/schema
      cp -r schema/* dist/schema/
    fi

    npm run build:prod

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/waveterm $out/bin

    # Copy frontend build output and metadata
    cp -r dist $out/share/waveterm/dist
    cp package.json $out/share/waveterm/package.json

    # Link Go backend binaries into dist/bin
    mkdir -p $out/share/waveterm/dist/bin
    cp -rs ${wavesrv}/bin/* $out/share/waveterm/dist/bin/

    # Expose wsh CLI tool in PATH
    ln -s ${wavesrv}/bin/wsh $out/bin/wsh

    # Wrap system electron
    makeWrapper ${electron}/bin/electron $out/bin/waveterm \
      --add-flags "$out/share/waveterm" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"

    # Icons
    for size in 16 32 48 64 128 256 512; do
      install -Dm644 build/icons/''${size}x''${size}.png \
        $out/share/icons/hicolor/''${size}x''${size}/apps/waveterm.png
    done
    install -Dm644 build/icons/512x512.png $out/share/pixmaps/waveterm.png

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "waveterm";
      exec = "waveterm %U";
      icon = "waveterm";
      desktopName = "Wave";
      genericName = "Terminal Emulator";
      comment = "Open-Source AI-Native Terminal Built for Seamless Workflows";
      startupWMClass = "Wave";
      categories = [
        "Development"
        "System"
        "TerminalEmulator"
      ];
    })
  ];

  passthru = {
    inherit wavesrv;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Open-Source AI-Native Terminal Built for Seamless Workflows";
    homepage = "https://www.waveterm.dev";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aliheidary1381 ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "waveterm";
  };
}
