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
  pname = "waveterm";
  version = "0.8.12";

  src =
    let
      inherit (stdenv.hostPlatform) system;
      selectSystem = attrs: attrs.${system} or (throw "Unsupported system: ${system}");
      suffix = selectSystem {
        x86_64-linux = "waveterm-linux-x64-${version}.zip";
        aarch64-linux = "waveterm-linux-arm64-${version}.zip";
        x86_64-darwin = "Wave-darwin-universal-${version}.zip ";
        aarch64-darwin = "Wave-darwin-arm64-${version}.zip";
      };
      hash = selectSystem {
        x86_64-linux = "sha256-lk+YBlsgS2kOsaesKJ0XMCnbxq5iza/0xG6qWjHLZA8=";
        aarch64-linux = "sha256-57j5qp/1jGiqJP6Qmfw5XkoyXkNpnaTepfhSzlISExM=";
        x86_64-darwin = "sha256-jBFkBC4PcWSQNw8A2w+2iUnSLoRvXQ3A0CVqkqfx4dI=";
        aarch64-darwin = "sha256-pQ3TXKhiCI164qmmDkDFb3WUjd/lX1MnAOWqsQICHR4=";
      };
    in
    fetchurl {
      url = "https://github.com/wavetermdev/waveterm/releases/download/v${version}/${suffix}";
      inherit hash;
    };

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
      meta
      passthru
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
      passthru
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
