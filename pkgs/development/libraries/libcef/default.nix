{ lib
, stdenv
, fetchurl
, cmake
, glib
, nss
, nspr
, atk
, at-spi2-atk
, libdrm
, expat
, libxcb
, libxkbcommon
, libX11
, libXcomposite
, libXdamage
, libXext
, libXfixes
, libXrandr
, mesa
, gtk3
, pango
, cairo
, alsa-lib
, dbus
, at-spi2-core
, cups
, libxshmfence
, obs-studio
}:

let
  gl_rpath = lib.makeLibraryPath [
    stdenv.cc.cc.lib
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
    mesa
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
  platforms."aarch64-linux".sha256 = "06n7c3zmkkvwp8pbx9inp9b9nn34qf6c9arz6sa039m7wbqfjpcc";
  platforms."x86_64-linux".sha256 = "0l08ln579hinbcv7phmdbli69i69plclgz3igianj7na684m9543";

  platformInfo = platforms.${stdenv.hostPlatform.system} or (throw "unsupported system ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation rec {
  pname = "cef-binary";
  version = "128.4.12";
  gitRevision = "1d7a1f9";
  chromiumVersion = "128.0.6613.138";

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
    mkdir -p $out/lib/ $out/share/cef/
    cp libcef_dll_wrapper/libcef_dll_wrapper.a $out/lib/
    cp ../Release/libcef.so $out/lib/
    cp ../Release/libEGL.so $out/lib/
    cp ../Release/libGLESv2.so $out/lib/
    patchelf --set-rpath "${rpath}" $out/lib/libcef.so
    patchelf --set-rpath "${gl_rpath}" $out/lib/libEGL.so
    patchelf --set-rpath "${gl_rpath}" $out/lib/libGLESv2.so
    cp ../Release/*.bin $out/share/cef/
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
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
