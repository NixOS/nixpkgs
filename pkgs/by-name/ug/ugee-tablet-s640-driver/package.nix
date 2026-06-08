{
  lib,
  stdenv,
  fetchzip,
  autoPatchelfHook,
  libx11,
  libxrandr,
  libGL,
  libgcc,
  libusb1,
  libxtst,
  libxi,
  libxinerama,
  libz,
  glib,
  dbus,
  libxext,
  libsm,
  libice,
  libxcb,
  fontconfig,
  freetype,
  libxrender,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ugee-s640-tablet-driver";
  version = "4.3.4";

  src = fetchzip {
    url = "https://download.ugee.com.cn/upload/download/20241217/ugeeTablet-4.3.4-241031.tar.gz";
    name = "${finalAttrs.pname}-${finalAttrs.version}.tar.gz";
    hash = "sha256-KCoDTnE7RhciCRVMnNXkTK0trkO5OsNNm29UWdnYD7E=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    libx11
    libxrandr
    libGL
    libgcc
    libusb1
    libxtst
    libxi
    libxinerama
    libz
    glib
    dbus
    libxext
    libsm
    libice
    libxcb
    fontconfig
    freetype
    libxrender
  ];

  buildInputs = [
  ];

  installPhase = ''
    AppDir=ugeeTablet

    #Copy rule
    sysRuleDir="/lib/udev/rules.d"
    appRuleDir=./App$sysRuleDir
    ruleName="ugee4-1.rules"

    mkdir -p $out$sysRuleDir
    cp $appRuleDir/$ruleName $out$sysRuleDir/$ruleName

    #install app
    sysAppDir="/usr/lib"
    appAppDir=./App$sysAppDir/$AppDir

    mkdir -p $out$sysAppDir
    cp -rf $appAppDir $out$sysAppDir

    ##install shortcut
    #sysDesktopDir=/usr/share/applications
    #sysAppIconDir=/usr/share/icons/hicolor/256x256/apps
    #sysAutoStartDir=/etc/xdg/autostart

    #appDesktopDir=./App$sysDesktopDir
    #appAppIconDir=./App$sysAppIconDir
    #appAutoStartDir=./App$sysAutoStartDir

    #appDesktopName=ugeetablet.desktop
    #appIconName=ugeetablet.png

    #cp $appDesktoopDir/$appDesktopName $out$sysDesktopDir/$appDesktopName
    #chmod +0555 $out$sysDesktopDir/$appDesktopName

    #cp $appAppIconDir/$appIconName $out$sysAppIconDir/$appIconName
    #chmod +0555 $out$sysAppIconDir/$appIconName

    #Copy config files
    chmod +0555 $out/usr/lib/ugeeTablet/ugeeTablet
    chmod +0555 $out/usr/lib/ugeeTablet/ugeeTabletDriver.sh
    chmod +0555 $out/usr/lib/ugeeTablet/ugeeTabletDriver
    confPath="/usr/lib/ugeeTablet/conf"

    chmod +0777 $out$confPath

    chmod +0666 $out$confPath/Ugee_Tablet.xml
    chmod +0666 $out$confPath/language.ini
    chmod +0666 $out$confPath/name_config.ini
    chmod +0666 $out/usr/lib/ugeeTablet/resource.rcc
  '';

  meta = {
    homepage = "https://www.ugee.com.cn/download/125.html";
    description = " Driver for ugee s640 drawing tablet. And if you are installing for the first time, please use it after restart.";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
  };
  platforms = [
    "x86_64-linux"
  ];

})
