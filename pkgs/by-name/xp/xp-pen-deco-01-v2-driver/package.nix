{
  lib,
  stdenv,
  fetchzip,
  libusb1,
  glibc,
  libGL,
  xorg,
  makeWrapper,
  libsForQt5,
  autoPatchelfHook,
  libX11,
  libXtst,
  libXi,
  libXrandr,
  libXinerama,
}:

let
  dataDir = "var/lib/xppend1v2";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "xp-pen-deco-01-v2-driver";
  version = "4.0.7-250117";

  src = fetchzip {
    url = "https://archive.org/download/xppen-linux-${finalAttrs.version}.tar/XPPenLinux${finalAttrs.version}.tar.gz";
    name = "xp-pen-deco-01-v2-driver-${finalAttrs.version}.tar.gz";
    hash = "sha256-sH05Qquo2u0npSlv8Par/mn1w/ESO9g42CCGwBauHhU=";
  };

  nativeBuildInputs = [
    libsForQt5.wrapQtAppsHook
    autoPatchelfHook
    makeWrapper
  ];

  dontBuild = true;

  dontWrapQtApps = true; # this is done manually

  buildInputs = [
    libusb1
    libX11
    libXtst
    libXi
    libXrandr
    libXinerama
    glibc
    libGL
    (lib.getLib stdenv.cc.cc)
    libsForQt5.qtx11extras
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{opt,bin}
    cp -r App/usr/lib/pentablet/{PenTablet,conf} $out/opt
    chmod +x $out/opt/PenTablet
    cp -r App/lib $out/lib
    sed -i 's#usr/lib/pentablet#${dataDir}#g' $out/opt/PenTablet

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper $out/opt/PenTablet $out/bin/xp-pen-deco-01-v2-driver \
      "''${qtWrapperArgs[@]}" \
      --run 'if [ "$EUID" -ne 0 ]; then echo "Please run as root."; exit 1; fi' \
      --run 'if [ ! -d /${dataDir} ]; then mkdir -p /${dataDir}; cp -r '$out'/opt/conf /${dataDir}; chmod u+w -R /${dataDir}; fi'
  '';

  meta = {
    homepage = "https://www.xp-pen.com/product/461.html";
    description = "Drivers for the XP-PEN Deco 01 v2 drawing tablet";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ virchau13 ];
    license = lib.licenses.unfree;
  };
})
