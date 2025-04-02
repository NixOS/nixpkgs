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
  obs-studio,
}:

let
  gl_rpath = lib.makeLibraryPath [
    stdenv.cc.cc
  ];

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
  ];
  platforms = {
    "aarch64-linux" = {
      platformStr = "linuxarm64";
      projectArch = "arm64";
    };
    "x86_64-linux" = {
      platformStr = "linux64";
      projectArch = "x86_64";
    };
  };
  platforms."aarch64-linux".sha256 = "0fkwgnas9d9mgfj9mcj0mrpi1pd6ghccgk9ad0bk0srxg2qmmp7p";
  platforms."x86_64-linux".sha256 = "0bjx0xqzfxsq4h5483gcdwl5p3m4q8c8wr84n9i2m603z4bdaq0c";

  platformInfo =
    platforms.${stdenv.hostPlatform.system}
      or (throw "unsupported system ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation rec {
  pname = "cef-binary";
  version = "134.3.9";
  gitRevision = "5dc6f2f";
  chromiumVersion = "134.0.6998.178";

  src = fetchurl {
    url = "https://cef-builds.spotifycdn.com/cef_binary_${version}+g${gitRevision}+chromium-${chromiumVersion}_${platformInfo.platformStr}_minimal.tar.bz2";
    inherit (platformInfo) sha256;
  };

  nativeBuildInputs = [ cmake ];
  cmakeFlags = [ "-DPROJECT_ARCH=${platformInfo.projectArch}" ];
  makeFlags = [ "libcef_dll_wrapper" ];
  dontStrip = true;
  dontPatchELF = true;

  installPhase = ''
    mkdir -p $out/lib/ $out/share/cef/ $out/libexec/cef/
    cp libcef_dll_wrapper/libcef_dll_wrapper.a $out/lib/
    cp ../Release/libcef.so $out/lib/
    cp ../Release/libEGL.so $out/lib/
    cp ../Release/libGLESv2.so $out/lib/
    cp ../Release/libvk_swiftshader.so $out/lib/
    cp ../Release/libvulkan.so.1 $out/lib/
    cp ../Release/chrome-sandbox $out/libexec/cef/
    patchelf --set-rpath "${rpath}" $out/lib/libcef.so
    patchelf --set-rpath "${gl_rpath}" $out/lib/libEGL.so
    patchelf --set-rpath "${gl_rpath}" $out/lib/libGLESv2.so
    patchelf --set-rpath "${gl_rpath}" $out/lib/libvk_swiftshader.so
    patchelf --set-rpath "${gl_rpath}" $out/lib/libvulkan.so.1
    cp ../Release/*.bin ../Release/*.json $out/share/cef/
    cp -r ../Resources/* $out/share/cef/
    cp -r ../include $out/
  '';

  passthru.tests = {
    inherit obs-studio; # frequently breaks on CEF updates
  };
  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Simple framework for embedding Chromium-based browsers in other applications";
    homepage = "https://cef-builds.spotifycdn.com/index.html";
    maintainers = with maintainers; [ puffnfresh ];
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryNativeCode
    ];
    license = licenses.bsd3;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
