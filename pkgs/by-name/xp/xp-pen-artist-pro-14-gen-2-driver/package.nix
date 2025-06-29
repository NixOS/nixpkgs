{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  libusb1,
  qt5,
}:

let
  dataDir = "var/lib/xppenap14";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "xp-pen-artist-pro-14-gen-2-driver";
  version = "4.0.4-240815";

  src = fetchurl {
    url = "https://download01.xp-pen.com/file/2024/08/XPPenLinux${finalAttrs.version}.tar.gz";
    hash = "sha256-Fd3Q3Z6UTmxU0DPfeyvf2hiNbiesIcl305NHmsjh1pk=";
  };

  buildInputs = [
    libusb1
    qt5.qtbase
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    qt5.wrapQtAppsHook
    makeWrapper
  ];

  dontConfigure = true;
  dontBuild = true;
  dontWrapQtApps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{opt,bin}

    cp -r App/usr/lib/pentablet/{PenTablet,conf,doc,UI} $out/opt
    cp -r App/lib $out/lib

    sed -i 's#usr/lib/pentablet#${dataDir}#g' $out/opt/PenTablet

    makeWrapper $out/opt/PenTablet $out/bin/PenTablet \
      "''${qtWrapperArgs[@]}" \
      --run 'if [ "$EUID" -ne 0 ]; then echo "Please run as root."; exit 1; fi' \
      --run 'if [ ! -d /${dataDir} ]; then mkdir -p /${dataDir}; cp -r '$out'/opt/conf /${dataDir}; chmod u+w -R /${dataDir}; fi'

    runHook postInstall
  '';

  meta = {
    homepage = "https://www.xp-pen.com/product/artist-pro-14-gen-2.html";
    description = "Driver for XP-PEN Artist Pro 14 (Gen 2) drawing tablet";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ gepbird ];
    license = lib.licenses.unfree;
    mainProgram = "PenTablet";
  };
})
