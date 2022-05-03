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
  platforms."aarch64-linux".sha256 = "1zdy3cm8avc6d4089a15w0yjhxw9mbdfyxf2hc0y0gy4bbwr3mb4";
  platforms."i686-linux".sha256 = "08msbhj2l2m0h7f14wdmn3wz6inpgl1piz2f4ya8rkwrddxpv6n9";
  platforms."x86_64-linux".sha256 = "0q72wym88ylph03m5xlzg0yzrqyx6496dhg2jdvlvs91x746bc3q";

  platformInfo = builtins.getAttr stdenv.targetPlatform.system platforms;
in
stdenv.mkDerivation rec {
  pname = "cef-binary";
  version = "101.0.15";
  gitRevision = "ca159c5";
  chromiumVersion = "101.0.4951.54";

  src = fetchurl {
    url = "https://cef-builds.spotifycdn.com/cef_binary_${version}+g${gitRevision}+chromium-${chromiumVersion}_${platformInfo.platformStr}_minimal.tar.bz2";
    inherit (platformInfo) sha256;
  };

  nativeBuildInputs = [ cmake ];
  cmakeFlags = "-DPROJECT_ARCH=${platformInfo.projectArch}";
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
    license = licenses.bsd3;
    platforms = [ "i686-linux" "x86_64-linux" "aarch64-linux" ];
  };
}
