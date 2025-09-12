{
  lib,
  stdenv,
  dpkg,
  autoPatchelfHook,
  alsa-lib,
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
  curl,
  makeWrapper,
  runCommandLocal,
  cacert,
  coreutils,
}:
let
  pkgVersion = "12.1.0.17900";
  url = "https://wps-linux-personal.wpscdn.cn/wps/download/ep/Linux2023/${lib.last (lib.splitVersion pkgVersion)}/wps-office_${pkgVersion}_amd64.deb";
  hash = "sha256-i2EVCmDLE2gx7l2aAo+fW8onP/z+xlPIbQYwKhQ46+o=";
  uri = builtins.replaceStrings [ "https://wps-linux-personal.wpscdn.cn" ] [ "" ] url;
  securityKey = "7f8faaaa468174dc1c9cd62e5f218a5b";
in
stdenv.mkDerivation rec {
  pname = "wpsoffice-cn";
  version = pkgVersion;

  src =
    runCommandLocal "wps-office_${version}_amd64.deb"
      {
        outputHashMode = "recursive";
        outputHashAlgo = "sha256";
        outputHash = hash;

        nativeBuildInputs = [
          curl
          coreutils
        ];

        impureEnvVars = lib.fetchers.proxyImpureEnvVars;
        SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
      }
      ''
        timestamp10=$(date '+%s')
        md5hash=($(echo -n "${securityKey}${uri}$timestamp10" | md5sum))
        curl \
        --retry 3 --retry-delay 3 \
        "${url}?t=$timestamp10&k=$md5hash" \
        > $out
      '';

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
    # libuof.so is a exclusive library in WPS. No need to repatch it
    "libuof.so"
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
  '';

  meta = with lib; {
    description = "Office suite, formerly Kingsoft Office";
    homepage = "https://www.wps.com";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    hydraPlatforms = [ ];
    license = licenses.unfree;
    maintainers = with maintainers; [
      mlatus
      th0rgal
      wineee
      pokon548
    ];
  };
}
