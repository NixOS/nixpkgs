{
  lib,
  stdenv,
  fetchurl,
  dpkg,
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
  libgbm,
  expat,
  libxcb,
  alsa-lib,
  nss,
  nspr,
  vips,
  wrapGAppsHook3,
  udev,
  libGL,
  unzip,
  makeWrapper,
}:
let
  selectSystem = attrs: attrs.${stdenv.hostPlatform.system};
  pname = "waveterm";
  version = "0.11.2";

  passthru.updateScript = ./update.sh;

  metaCommon = {
    description = "Open-source, cross-platform terminal for seamless workflows";
    homepage = "https://www.waveterm.dev";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.asl20;
    platforms = [
      "aarch64-linux"
      "aarch64-darwin"
      "x86_64-linux"
      "x86_64-darwin"
    ];
    maintainers = with lib.maintainers; [ ];
  };

  linux = stdenv.mkDerivation {
    inherit pname version passthru;

    src =
      let
        arch = selectSystem {
          x86_64-linux = "amd64";
          aarch64-linux = "arm64";
        };
      in
      fetchurl {
        url = "https://github.com/wavetermdev/waveterm/releases/download/v${version}/waveterm-linux-${arch}-${version}.deb";
        hash = selectSystem {
          x86_64-linux = "sha256-KsE7/L5fRnpAdvcHkZGk3s0qKRDfyO00UtNH0uaCs78=";
          aarch64-linux = "sha256-l2Uz2y4GQhU0UNtPMumWPPdpMqmZH1i79gg53V3wfA8=";
        };
      };

    nativeBuildInputs = [
      dpkg
      autoPatchelfHook
      wrapGAppsHook3
      makeWrapper
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
      libgbm
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

      cp -r opt $out
      cp -r usr/share $out/share
      substituteInPlace $out/share/applications/waveterm.desktop \
        --replace-fail "/opt/Wave/" ""

      runHook postInstall
    '';

    preFixup = ''
      mkdir $out/bin
      makeWrapper $out/Wave/waveterm $out/bin/waveterm \
        --prefix LD_LIBRARY_PATH : "${
          lib.makeLibraryPath [
            libGL
          ]
        }"
    '';

    meta = metaCommon // {
      mainProgram = "waveterm";
    };
  };

  darwin = stdenv.mkDerivation {
    inherit pname version passthru;

    src =
      let
        arch = selectSystem {
          x86_64-darwin = "x64";
          aarch64-darwin = "arm64";
        };
      in
      fetchurl {
        url = "https://github.com/wavetermdev/waveterm/releases/download/v${version}/Wave-darwin-${arch}-${version}.zip";
        hash = selectSystem {
          x86_64-darwin = "sha256-SWISlOG/NIrp7leCCSI4yH8k30Ky280yMY+yirLNGfA=";
          aarch64-darwin = "sha256-9zNYpUP2KizYWUr3+o6lBgGP9S9VwIrfcY9E3L+o3KU=";
        };
      };

    nativeBuildInputs = [
      unzip
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/Applications
      cp -r . "$out/Applications/Wave.app"

      runHook postInstall
    '';

    meta = metaCommon // {
      mainProgram = "Wave";
    };
  };
in
if stdenv.hostPlatform.isDarwin then darwin else linux
