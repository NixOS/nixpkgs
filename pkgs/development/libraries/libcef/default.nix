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
    "i686-linux" = {
      platformStr = "linux32";
      projectArch = "x86";
    };
    "x86_64-linux" = {
      platformStr = "linux64";
      projectArch = "x86_64";
    };
  };
  platforms."aarch64-linux".sha256 = "0gmnmr0zn2ffn7xbhmfh6rhmwmxy5zzlj0s3lyp99knjn47lg2fg";
  platforms."i686-linux".sha256 = "1lp2z9db89qk2wh900c2dzlhflwmcbmp4m7xnlj04pq4q2kgfm9p";
  platforms."x86_64-linux".sha256 = "1ljrp0iky7rrj04sbqicrg1jr938xnid6jlirbf7gwlmzliz3wfs";

  platformInfo = builtins.getAttr stdenv.targetPlatform.system platforms;
in
stdenv.mkDerivation rec {
  pname = "cef-binary";
  version = "100.0.24";
  gitRevision = "0783cf8";
  chromiumVersion = "100.0.4896.127";

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
    patchelf --set-rpath "${rpath}" $out/lib/libcef.so
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
    platforms = [ "i686-linux" "x86_64-linux" "aarch64-linux" ];
  };
}
