{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  squashfsTools,
  makeBinaryWrapper,
  alsa-lib,
  atk,
  at-spi2-atk,
  cups,
  gtk3,
  libdrm,
  libsecret,
  libxkbcommon,
  libgbm,
  libGL,
  pango,
  sqlite,
  systemd,
  wayland,
  xorg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tradingview";
  version = "2.14.0";
  revision = "68";

  src = fetchurl {
    url = "https://api.snapcraft.io/api/v1/snaps/download/nJdITJ6ZJxdvfu8Ch7n5kH5P99ClzBYV_${finalAttrs.revision}.snap";
    hash = "sha512-wuMQBfJfMbQdq4eUNl9bitf4IGcpczX0FDdnQAgyALBpHI7CbcIF9Aq4hIy0dblYgeISM1HFqPiSIcFCS+VuSQ==";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeBinaryWrapper
    squashfsTools
  ];

  buildInputs = [
    (lib.getLib stdenv.cc.cc)
    alsa-lib
    atk
    at-spi2-atk
    cups
    gtk3
    libdrm
    libsecret
    libxkbcommon
    libgbm
    libGL
    pango
    sqlite
    systemd
    wayland
    xorg.libxcb
    xorg.libX11
    xorg.libXext
  ];

  unpackPhase = ''
    runHook preUnpack

    unsquashfs $src

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    cp -r squashfs-root $out/share/tradingview
    rm -rf $out/share/tradingview/meta
    substituteInPlace squashfs-root/meta/gui/tradingview.desktop \
      --replace-fail \$\{SNAP}/meta/gui/icon.png tradingview
    install -D --mode 644 squashfs-root/meta/gui/tradingview.desktop -t $out/share/applications
    install -D --mode 644 squashfs-root/meta/gui/icon.png $out/share/icons/hicolor/512x512/apps/tradingview.png
    mkdir $out/bin
    makeWrapper $out/share/tradingview/tradingview $out/bin/tradingview \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath finalAttrs.buildInputs}

    runHook postInstall
  '';

  preFixup = ''
    patchelf --add-needed libGL.so.1 $out/share/tradingview/tradingview
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Charting platform for traders and investors";
    homepage = "https://www.tradingview.com/desktop/";
    changelog = "https://www.tradingview.com/support/solutions/43000673888/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ prominentretail ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "tradingview";
  };
})
