{
  lib,
  stdenv,
  fetchurl,
  appimageTools,
  makeWrapper,
  tor,
  trezord,
}:

appimageTools.wrapType2 (finalAttrs: {
  pname = "trezor-suite";
  version = "26.10.3";

  src = fetchurl {
    url = "https://github.com/trezor/trezor-suite/releases/download/v${finalAttrs.version}/Trezor-Suite-${finalAttrs.version}-${finalAttrs.suffix}.AppImage";
    hash =
      {
        # curl -Lfs https://github.com/trezor/trezor-suite/releases/download/v${version}/latest-linux{-arm64,}.yml | grep ^sha512 | sed 's/: /-/'
        aarch64-linux = "sha512-tB5KN6gV4G/Gegz3t4cdU+ybsKCzeurmJ8RyohlTrSwNMChMlGiLyiuswYAlUM0TDd/DgYwFPuxBufucf7ZYyA==";
        x86_64-linux = "sha512-tXw9HUCKx5d715ORS0GAoZCHiIQLYLy0tv1xb0PY0h4WZIU4C/tx/FBu14yoEvECr209qCYJuCKC1JGi1cU1Eg==";
      }
      .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  };

  suffix =
    {
      aarch64-linux = "linux-arm64";
      x86_64-linux = "linux-x86_64";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  nativeBuildInputs = [ makeWrapper ];

  extraInstallCommands = ''
    mkdir -p $out/bin $out/share/trezor-suite $out/share/trezor-suite/resources

    cp -a ${finalAttrs.contents}/locales/ $out/share/trezor-suite
    cp -a ${finalAttrs.contents}/resources/app*.* $out/share/trezor-suite/resources
    cp -a ${finalAttrs.contents}/resources/images/ $out/share/trezor-suite/resources

    wrapProgram $out/bin/trezor-suite \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"

    install -m 444 -D ${finalAttrs.contents}/trezor-suite.desktop $out/share/applications/trezor-suite.desktop
    install -m 444 -D ${finalAttrs.contents}/resources/images/desktop/512x512.png $out/share/icons/hicolor/512x512/apps/trezor-suite.png
    substituteInPlace $out/share/applications/trezor-suite.desktop \
      --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=trezor-suite'

    # symlink system binaries instead bundled ones
    mkdir -p $out/share/trezor-suite/resources/bin/{bridge,tor}
    ln -sf ${trezord}/bin/trezord-go $out/share/trezor-suite/resources/bin/bridge/trezord
    ln -sf ${tor}/bin/tor $out/share/trezor-suite/resources/bin/tor/tor
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Trezor Suite - Desktop App for managing crypto";
    homepage = "https://suite.trezor.io";
    changelog = "https://github.com/trezor/trezor-suite/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ prusnak ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    mainProgram = "trezor-suite";
  };
})
