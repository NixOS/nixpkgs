{
  lib,
  stdenv,
  dpkg,
  autoPatchelfHook,
  alsa-lib,
  fetchurl,
  at-spi2-core,
  libtool,
  libxkbcommon,
  nspr,
  mesa,
  libtiff,
  udev,
  gtk3,
  libsForQt5,
  xorg,
  cups,
  pango,
  libjpeg,
  gtk2,
  gdk-pixbuf,
  libpulseaudio,
  libbsd,
  libusb1,
  libmysqlclient,
  llvmPackages,
  dbus,
  gcc-unwrapped,
  freetype,
  makeWrapper,
  oemIniFilePath ? "",
}:
let
  sources = import ./sources.nix;
in
stdenv.mkDerivation rec {
  pname = "wpsoffice-365";
  version = sources.version;

  src =
    {
      x86_64-linux = fetchurl {
        url = sources.amd64_url;
        hash = sources.amd64_hash;
      };
      aarch64-linux = fetchurl {
        url = sources.arm64_url;
        hash = sources.arm64_hash;
      };
    }
    .${stdenv.system} or (throw "${pname}-${version}: ${stdenv.system} is unsupported.");

  unpackCmd = "dpkg -x $src .";
  sourceRoot = ".";

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    at-spi2-core
    libtool
    libjpeg
    libxkbcommon
    nspr
    mesa
    libtiff
    udev
    gtk3
    libsForQt5.qt5.qtbase
    xorg.libXdamage
    xorg.libXtst
    xorg.libXv
    gtk2
    gdk-pixbuf
    libpulseaudio
    xorg.libXScrnSaver
    xorg.libXxf86vm
    libbsd
    libusb1
    libmysqlclient
    llvmPackages.openmp
    dbus
    libsForQt5.fcitx5-qt
  ];

  dontWrapQtApps = true;

  runtimeDependencies = map lib.getLib [
    cups
    pango
    freetype
    gcc-unwrapped.lib
  ];

  autoPatchelfIgnoreMissingDeps = [
    # distribution is missing libkappessframework.so
    "libkappessframework.so"
    # qt4 support is deprecated
    "libQtCore.so.4"
    "libQtNetwork.so.4"
    "libQtXml.so.4"
    # file manager integration. Not needed
    "libnautilus-extension.so.1"
    "libcaja-extension.so.1"
    "libpeony.so.3"
  ];

  installPhase = ''
    runHook preInstall
    prefix=$out/opt/kingsoft/wps-office
    mkdir -p $out
    cp -r opt $out
    cp -r usr/* $out
    for i in wps wpp et wpspdf; do
      substituteInPlace $out/bin/$i \
        --replace /opt/kingsoft/wps-office $prefix
    done
    for i in $out/share/applications/*;do
      substituteInPlace $i \
        --replace /usr/bin $out/bin
    done
    # custom oem.ini if needed. Suitable for enterprise users
    if [ ! -z "${oemIniFilePath}" ]; then
      ln -sf "${oemIniFilePath}" $out/opt/kingsoft/wps-office/office6/cfgs/oem.ini
      ln -sf "${oemIniFilePath}" $out/opt/kingsoft/wps-office/office6/wtool/oem.ini
    fi
    # need system freetype and gcc lib to run properly
    for i in wps wpp et wpspdf wpsoffice; do
      wrapProgram $out/opt/kingsoft/wps-office/office6/$i \
        --set LD_PRELOAD "${freetype}/lib/libfreetype.so" \
        --set LD_LIBRARY_PATH "${lib.makeLibraryPath [ gcc-unwrapped.lib ]}"
    done
    runHook postInstall
  '';

  preFixup = ''
    # The following libraries need libtiff.so.5, but nixpkgs provides libtiff.so.6
    patchelf --replace-needed libtiff.so.5 libtiff.so $out/opt/kingsoft/wps-office/office6/{libpdfmain.so,libqpdfpaint.so,qt/plugins/imageformats/libqtiff.so,addons/pdfbatchcompression/libpdfbatchcompressionapp.so}
    patchelf --replace-needed libtiff.so.5 libtiff.so $out/opt/kingsoft/wps-office/office6/addons/ksplitmerge/libksplitmergeapp.so
    patchelf --add-needed libtiff.so $out/opt/kingsoft/wps-office/office6/libwpsmain.so
    # Fix: Wrong JPEG library version: library is 62, caller expects 80
    patchelf --add-needed libjpeg.so $out/opt/kingsoft/wps-office/office6/libwpsmain.so
    # dlopen dependency
    patchelf --add-needed libudev.so.1 $out/opt/kingsoft/wps-office/office6/addons/cef/libcef.so
    patchelf --replace-needed libmysqlclient.so.18 libmysqlclient.so $out/opt/kingsoft/wps-office/office6/libFontWatermark.so
    patchelf --add-rpath "${libmysqlclient}/lib/mariadb" $out/opt/kingsoft/wps-office/office6/libFontWatermark.so
    patchelf --replace-needed libFcitxQt5DBusAddons.so.1 libFcitx5Qt5DBusAddons.so.1 $out/opt/xiezuo/resources/qt-tools/platforminputcontexts/libfcitxplatforminputcontextplugin.so
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Office suite, formerly Kingsoft Office";
    homepage = "https://365.wps.cn";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    hydraPlatforms = [ ];
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ pokon548 ];
  };
}
