{
  lib,
  stdenv,
  fetchurl,
  cmake,
  glib,
  nss,
  nspr,
  atk,
  at-spi2-atk,
  libdrm,
  expat,
  libxcb,
  libxkbcommon,
  libX11,
  libXcomposite,
  libXdamage,
  libXext,
  libXfixes,
  libXrandr,
  libgbm,
  gtk3,
  pango,
  cairo,
  alsa-lib,
  dbus,
  at-spi2-core,
  cups,
  libxshmfence,
  libGL,
  udev,
  systemd,
  obs-studio,
  xorg,
}:

let
  gl_rpath = lib.makeLibraryPath [ stdenv.cc.cc ];

  rpath = lib.makeLibraryPath [
    glib
    nss
    nspr
    atk
    at-spi2-atk
    libdrm
    expat
    libxcb
    libxkbcommon
    libX11
    libXcomposite
    libXdamage
    libXext
    libXfixes
    libXrandr
    libgbm
    gtk3
    pango
    cairo
    alsa-lib
    dbus
    at-spi2-core
    cups
    libxshmfence
    libGL
    udev
    systemd
    xorg.libxcb
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
    xorg.libxshmfence
  ];

  selectSystem =
    attrs:
    attrs.${stdenv.hostPlatform.system} or (throw "Unsupported system ${stdenv.hostPlatform.system}");

  platformInfo = selectSystem {
    aarch64-linux = {
      platformStr = "linuxarm64";
      projectArch = "arm64";
    };
    x86_64-linux = {
      platformStr = "linux64";
      projectArch = "x86_64";
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "libcef";
  version = "140.1.14";
  gitRevision = "eb1c06e";
  chromiumVersion = "140.0.7339.185";
  buildType = "Release";

  srcHash = selectSystem {
    aarch64-linux = "sha256-psgs+RcEYWKN4NneU4eVIaV2b7y+doxdPs9QWsN8dTA=";
    x86_64-linux = "sha256-CDVzU+GIAU6hEutot90GMlAS8xEqD3uNLppgGq9d4mE=";
  };

  src = fetchurl {
    url = "https://cef-builds.spotifycdn.com/cef_binary_${finalAttrs.version}+g${finalAttrs.gitRevision}+chromium-${finalAttrs.chromiumVersion}_${platformInfo.platformStr}_minimal.tar.bz2";
    hash = finalAttrs.srcHash;
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DPROJECT_ARCH=${platformInfo.projectArch}" ];

  makeFlags = [ "libcef_dll_wrapper" ];

  dontStrip = true;

  dontPatchELF = true;

  preInstall = ''
    patchelf --set-rpath "${rpath}" --set-interpreter "${stdenv.cc.bintools.dynamicLinker}" ../${finalAttrs.buildType}/chrome-sandbox
    patchelf --add-needed libudev.so --set-rpath "${rpath}" ../${finalAttrs.buildType}/libcef.so
    patchelf --set-rpath "${gl_rpath}" ../${finalAttrs.buildType}/libEGL.so
    patchelf --add-needed libGL.so.1 --set-rpath "${gl_rpath}" ../${finalAttrs.buildType}/libGLESv2.so
    patchelf --set-rpath "${gl_rpath}" ../${finalAttrs.buildType}/libvk_swiftshader.so
    patchelf --set-rpath "${gl_rpath}" ../${finalAttrs.buildType}/libvulkan.so.1
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/ $out/share/cef/ $out/libexec/cef/
    cp libcef_dll_wrapper/libcef_dll_wrapper.a $out/lib/
    cp ../${finalAttrs.buildType}/libcef.so $out/lib/
    cp ../${finalAttrs.buildType}/libEGL.so $out/lib/
    cp ../${finalAttrs.buildType}/libGLESv2.so $out/lib/
    cp ../${finalAttrs.buildType}/libvk_swiftshader.so $out/lib/
    cp ../${finalAttrs.buildType}/libvulkan.so.1 $out/lib/
    cp ../${finalAttrs.buildType}/chrome-sandbox $out/libexec/cef/
    cp ../${finalAttrs.buildType}/*.bin ../${finalAttrs.buildType}/*.json $out/share/cef/
    cp -r ../Resources/* $out/share/cef/
    cp -r ../include $out/

    runHook postInstall
  '';

  passthru = {
    updateScript = ./update.sh;
    tests = {
      inherit obs-studio; # frequently breaks on CEF updates
    };
  };

  meta = {
    description = "Simple framework for embedding Chromium-based browsers in other applications";
    homepage = "https://cef-builds.spotifycdn.com/index.html";
    maintainers = with lib.maintainers; [ puffnfresh ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode
    ];
    license = lib.licenses.bsd3;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
