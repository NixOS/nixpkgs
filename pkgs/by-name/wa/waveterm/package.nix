{
  lib,
  stdenv,
  fetchurl,
  makeDesktopItem,
  copyDesktopItems,
  unzip,
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
}:

let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  pname = "waveterm";
  version = "0.8.7";

  suffix =
    {
      x86_64-linux = "waveterm-linux-x64-${version}.zip";
      aarch64-linux = "waveterm-linux-arm64-${version}.zip";
      x86_64-darwin = "Wave-darwin-universal-${version}.zip ";
      aarch64-darwin = "Wave-darwin-arm64-${version}.zip";
    }
    .${system} or throwSystem;

  src = fetchurl {
    url = "https://github.com/wavetermdev/waveterm/releases/download/v${version}/${suffix}";
    hash =
      {
        x86_64-linux = "sha256-pWBKZid8sumi/EP3DA5KcLnZsHsuKYK6E6NHXdWKh8s=";
        aarch64-linux = "sha256-2paRX+OGPSEktV4S+V43ZE9UgltLYZ+Nyba5/miBQkA=";
        x86_64-darwin = "sha256-tsqw597gQIMnQ/OPZhrWwaRliF94KyS+ryajttDLqBA=";
        aarch64-darwin = "sha256-PD38UBSNKuv836P/py/CtrLOlddHa0+w7R20YVY4Ybc=";
      }
      .${system} or throwSystem;
  };

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

  unpackPhase = ''
    runHook preUnpack
    unzip ${src} -d ./
    runHook postUnpack
  '';

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
      src
      desktopItems
      unpackPhase
      ;

    nativeBuildInputs = [
      unzip
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
      mkdir -p $out/waveterm $out/bin
      cp -r ./* $out/waveterm/
      runHook postInstall
    '';

    preFixup = ''
      makeWrapper $out/waveterm/waveterm $out/bin/waveterm \
        --prefix LD_LIBRARY_PATH : "${
          lib.makeLibraryPath [
            libGL
          ]
        }"
    '';
  };

  darwin = stdenv.mkDerivation {
    inherit
      pname
      version
      src
      unpackPhase
      meta
      ;

    nativeBuildInputs = [
      unzip
    ];

    sourceRoot = "Wave.app";

    installPhase = ''
      runHook preInstall
      mkdir -p $out/Applications/Wave.app
      cp -R . $out/Applications/Wave.app
      runHook postInstall
    '';
  };
in
if stdenv.hostPlatform.isDarwin then darwin else linux
