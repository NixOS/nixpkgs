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
  udev,
  libGL,
  unzip,
}:
let
  selectSystem = attrs: attrs.${stdenv.hostPlatform.system};
  pname = "waveterm";
  version = "0.12.0";

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
    maintainers = [ ];
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
          x86_64-linux = "sha256-pITwfh83l8KffGh76bIec6KdzT8AuL1vhFxU/8O6Mk4=";
          aarch64-linux = "sha256-v/3Vi59J9TqJ2V5616Y3muOQK1CKAKdBvw+txuLG8EM=";
        };
      };

    nativeBuildInputs = [
      dpkg
      autoPatchelfHook
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

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin $out/app
      cp -r opt/Wave $out/app/waveterm
      cp -r usr/share $out/share
      substituteInPlace $out/share/applications/waveterm.desktop \
        --replace-fail "/opt/Wave/" ""
      ln -s $out/app/waveterm/waveterm $out/bin/waveterm

      runHook postInstall
    '';

    preFixup = ''
      patchelf --add-needed libGL.so.1 \
        --add-rpath ${
          lib.makeLibraryPath [
            libGL
            udev
          ]
        } $out/app/waveterm/waveterm
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
          x86_64-darwin = "sha256-4yuwnZQFxGXAcMoZINpKkgg4VjfX2ZOKM95deaFWuvA=";
          aarch64-darwin = "sha256-tfCCh6gOyRCl2fe3nPhTLr/Wb6tCYnpL2h2T6d5viRA=";
        };
      };

    nativeBuildInputs = [ unzip ];

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
