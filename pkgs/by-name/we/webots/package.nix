{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  bash,
  makeWrapper,
  alsa-lib,
  fontconfig,
  freetype,
  glib,
  gtk3,
  krb5,
  libGL,
  libGLU,
  libx11,
  libxext,
  libxi,
  libxkbcommon,
  libxcb,
  libxrender,
  libxcb-util,
  libgcrypt,
  libssh,
  libxml2_13,
  libzip,
  openal,
  sndio,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "webots";
  version = "R2025a";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://github.com/cyberbotics/webots/releases/download/${finalAttrs.version}/webots-${finalAttrs.version}-x86-64.tar.bz2";
    hash = "sha256-xRJ/tCBsV6WuVSPxt/Pai2cLyJJtmuCFleE58ibzjDg=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    fontconfig
    freetype
    glib
    gtk3
    krb5
    libGL
    libGLU
    libx11
    libxext
    libxi
    libxkbcommon
    libxcb
    libxrender
    libxcb-util
    libgcrypt
    libssh
    libxml2_13
    libzip
    openal
    sndio
    stdenv.cc.cc.lib
    zlib
  ];

  dontConfigure = true;
  dontBuild = true;

  # Some bundled libraries reference unavailable legacy Imath and Qt Wayland
  # dependencies. The tested X11/XWayland functionality does not require them.
  autoPatchelfIgnoreMissingDeps = [
    "libImath-2_5.so.25"
    "libQt6WlShellIntegration.so.6"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share" "$out/bin"
    cp -a . "$out/share/webots"

    substituteInPlace "$out/share/webots/webots" \
      --replace-fail '#!/bin/bash' '#!${lib.getExe bash}'

    makeWrapper "$out/share/webots/webots" "$out/bin/webots" \
      --set WEBOTS_HOME "$out/share/webots"

    makeWrapper "$out/share/webots/webots-controller" "$out/bin/webots-controller" \
      --set WEBOTS_HOME "$out/share/webots"

    runHook postInstall
  '';

  meta = {
    description = "Open-source robot simulator";
    homepage = "https://cyberbotics.com/";
    license = lib.licenses.asl20;
    mainProgram = "webots";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [ Kyamel ];
  };
})
