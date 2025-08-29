{
  lib,
  stdenv,
  fetchzip,
  autoPatchelfHook,
  libusb1,
  libX11,
  libXtst,
  qt5,
  libglvnd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xp-pen-g430-driver";
  version = "1.2.13.1";

  src = fetchzip {
    url = "https://archive.org/download/linux-pentablet-v-1.2.13.1.tar.gz-20200428/Linux_Pentablet_V1.2.13.1.tar.gz%2820200428%29.zip/Linux_Pentablet_V1.2.13.1.tar.gz";
    name = "xp-pen-g430-driver-${finalAttrs.version}.tar.gz";
    hash = "sha256-Wavf4EAzR/NX3GOfdAEdFX08gkD03FVvAkIl37Zmipc=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    libusb1
    libX11
    libXtst
    qt5.qtbase
    libglvnd
    (lib.getLib stdenv.cc.cc)
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp Pentablet_Driver $out/bin/pentablet-driver
    cp config.xml $out/bin/config.xml
  '';

  meta = {
    homepage = "https://www.xp-pen.com/download-46.html";
    description = "Driver for XP-PEN Pentablet drawing tablets";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ ];
  };
})
