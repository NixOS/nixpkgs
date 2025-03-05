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
  inherit (stdenv.hostPlatform) system;
  selectSystem = attrs: attrs.${system};
  pname = "waveterm";
  version = "0.9.3";
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
        suffix = selectSystem {
          x86_64-linux = "waveterm-linux-x64";
          aarch64-linux = "waveterm-linux-arm64";
        };
        hash = selectSystem {
          x86_64-linux = "sha256-zmmWQnZklnmhVrZp0F0dkVHVMW+K/VynSvbF9Zer/RE=";
          aarch64-linux = "sha256-HRZRRUV6CVqUQYuvXBmnNcAsbZwgNDZiEf+gjdLDaPQ=";
        };
      in
      fetchzip {
        url = "https://github.com/wavetermdev/waveterm/releases/download/v${version}/${suffix}-${version}.zip";
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

  darwin = stdenv.mkDerivation rec {
    inherit
      pname
      version
      meta
      passthru
      ;

    src =
      let
        suffix = selectSystem {
          x86_64-darwin = "Wave-darwin-x64";
          aarch64-darwin = "Wave-darwin-arm64";
        };
        hash = selectSystem {
          x86_64-darwin = "sha256-NSpNWUWdRkB2H5l/WnI/Xyv68h0OXX7SIKyDAq0LIJM=";
          aarch64-darwin = "sha256-QkJMrmqrveFc2StL5gVpE78DlC1OBcEV+tY7p2nJ/6I=";
        };
      in
      fetchurl {
        url = "https://github.com/wavetermdev/waveterm/releases/download/v${version}/${suffix}-${version}.zip";
        inherit hash;
      };

    nativeBuildInputs = [
      unzip
    ];

    unpackPhase = ''
      runHook preUnpack

      unzip ${src} -d ./

      runHook postUnpack
    '';

    sourceRoot = "Wave.app";

    installPhase = ''
      runHook preInstall

      mkdir -p $out/Applications/Wave.app
      cp -r . $out/Applications/Wave.app

      runHook postInstall
    '';
  };
in
if stdenv.hostPlatform.isDarwin then darwin else linux
