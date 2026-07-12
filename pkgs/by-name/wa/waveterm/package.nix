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
  libx11,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxrandr,
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
  version = "0.13.1";

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
          x86_64-linux = "sha256-q2rdc/DpVVRDK2X9QyS8w7gkHZAQR+Wopn40Vip9CeE=";
          aarch64-linux = "sha256-hPcZp0mBzEnaY+e+Kg5XynROWduydutQ2davhLg9bI4=";
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
      libx11
      libxcomposite
      libxdamage
      libxext
      libxfixes
      libxrandr
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
          x86_64-darwin = "sha256-U22AVln0IhGrL41YUbJMi2agjfAs1N8Zd6msElpAXD8=";
          aarch64-darwin = "sha256-NY/KFFGgtrQr9YL32nudWeTIGNDjswelcOD1wo+Jh3s=";
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
