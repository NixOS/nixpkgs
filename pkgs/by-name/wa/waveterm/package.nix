{
  lib,
  stdenv,
  fetchurl,
  makeDesktopItem,
  copyDesktopItems,
  autoPatchelfHook,
  atk,
  at-spi2-atk,
  cups,
  libdrm,
  gtk3,
  pango,
  cairo,
  libX11,
  libXcomposite,
  libXdamage,
  libXext,
  libXfixes,
  libXrandr,
  mesa,
  expat,
  libxcb,
  alsa-lib,
  nss,
  nspr,
  vips,
  wrapGAppsHook3,
  udev,
  libGL,
  fetchzip,
  unzip,
}:
let
  selectSystem = attrs: attrs.${stdenv.hostPlatform.system};
  pname = "waveterm";
  version = "0.10.0";
  passthru.updateScript = ./update.sh;

  desktopItems = [
    (makeDesktopItem {
      name = "waveterm";
      exec = "waveterm --no-sandbox %U";
      icon = fetchurl {
        url = "https://raw.githubusercontent.com/wavetermdev/waveterm/refs/tags/v${version}/build/appicon.png";
        hash = "sha256-qob27/64C9XPBtXghxg5/g0qRaiOUOpuFYL1n7/aEB0=";
      };
      startupWMClass = "Wave";
      comment = "Open-Source AI-Native Terminal Built for Seamless Workflows";
      desktopName = "Wave";
      genericName = "Terminal Emulator";
      categories = [
        "Development"
        "Utility"
        "TerminalEmulator"
      ];
      keywords = [
        "developer"
        "terminal"
        "emulator"
      ];
    })
  ];

  meta = {
    description = "Open-source, cross-platform terminal for seamless workflows";
    homepage = "https://www.waveterm.dev";
    mainProgram = "waveterm";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.asl20;
    platforms = [
      "aarch64-linux"
      "aarch64-darwin"
      "x86_64-linux"
      "x86_64-darwin"
    ];
    maintainers = with lib.maintainers; [ aucub ];
  };

  linux = stdenv.mkDerivation {
    inherit
      pname
      version
      desktopItems
      meta
      passthru
      ;

    src =
      let
        arch = selectSystem {
          x86_64-linux = "x64";
          aarch64-linux = "arm64";
        };
        hash = selectSystem {
          x86_64-linux = "sha256-8q106czSyn+2VauUpPp06yZl3tlQk64s6eB74h/mO9s=";
          aarch64-linux = "sha256-HxzTCM2csXMqXNyNoyJ+gyyV/n5P61W6lVMgKGGFXBA=";
        };
      in
      fetchzip {
        url = "https://github.com/wavetermdev/waveterm/releases/download/v${version}/waveterm-linux-${arch}-${version}.zip";
        inherit hash;
        stripRoot = false;
      };

    nativeBuildInputs = [
      copyDesktopItems
      autoPatchelfHook
      wrapGAppsHook3
    ];

    buildInputs = [
      atk
      at-spi2-atk
      cups
      libdrm
      gtk3
      pango
      cairo
      libX11
      libXcomposite
      libXdamage
      libXext
      libXfixes
      libXrandr
      mesa
      expat
      libxcb
      alsa-lib
      nss
      nspr
      vips
    ];

    runtimeDependencies = map lib.getLib [
      udev
    ];

    installPhase = ''
      runHook preInstall

      mkdir $out
      cp -r . $out/waveterm

      runHook postInstall
    '';

    preFixup = ''
      mkdir $out/bin
      makeWrapper $out/waveterm/waveterm $out/bin/waveterm \
        --prefix LD_LIBRARY_PATH : "${
          lib.makeLibraryPath [
            libGL
          ]
        }"
    '';
  };

  darwin = stdenv.mkDerivation rec {
    inherit
      pname
      version
      meta
      passthru
      ;

    src =
      let
        arch = selectSystem {
          x86_64-darwin = "x64";
          aarch64-darwin = "arm64";
        };
        hash = selectSystem {
          x86_64-darwin = "sha256-LdB0WXxUAxB7yDC+tWx6/qZClyMidExBIpitY3qUC1Q=";
          aarch64-darwin = "sha256-JEMq/N6d6lHpXag8stAi8s5dV61V5cfc9QADVLmYzeQ=";
        };
      in
      fetchurl {
        url = "https://github.com/wavetermdev/waveterm/releases/download/v${version}/Wave-darwin-${arch}-${version}.zip";
        inherit hash;
      };

    nativeBuildInputs = [
      unzip
    ];

    sourceRoot = "Wave.app";

    installPhase = ''
      runHook preInstall

      mkdir -p $out/Applications
      cp -r . $out/Applications/Wave.app

      runHook postInstall
    '';
  };
in
if stdenv.hostPlatform.isDarwin then darwin else linux
