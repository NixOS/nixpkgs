{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeShellWrapper,
  # wpsoffice dependencies
  alsa-lib,
  libjpeg,
  libtool,
  libxkbcommon,
  nspr,
  udev,
  gtk3,
  libgbm,
  libusb1,
  unixODBC,
  libbsd,
  libxxf86vm,
  libpulseaudio,
  libsForQt5,
  xorg,
  libmysqlclient,
  # xiezuo dependencies
  # ...
  # wpsoffice runtime dependencies
  cups,
  dbus,
  pango,
}:

let
  pname = "wpsoffice-365";
  version = "12.1.2.23578";

  passthru = {
    sources = {
      x86_64-linux = fetchurl {
        name = "wpsoffice-365-${version}.deb";
        url = "https://pubwps-wps365-obs.wpscdn.cn/download/Linux/23578/wps-office_12.1.2.23578.AK.preread.sw_542884_amd64.deb";
        hash = "sha256-z7SuFQUS4s+vEbhShoUVKlfb/9oROmf8IWj5qkxqAew=";
      };
      aarch64-linux = fetchurl {
        name = "wpsoffice-365-${version}.deb";
        url = "https://pubwps-wps365-obs.wpscdn.cn/download/Linux/23578/wps-office_12.1.2.23578.AK.preread.sw_542882_arm64.deb";
        hash = "sha256-SZHTNWyv76TRYPoPDdtYK8zcS5dRJ6jZhowF2Inl1Sw=";
      };
    };
    updateScript = ./update.sh;
  };

  src =
    passthru.sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  meta = {
    description = "Office suite, formerly Kingsoft Office";
    homepage = "https://365.wps.cn";
    platforms = builtins.attrNames passthru.sources;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    hydraPlatforms = [ ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      wineee
      pokon548
      chillcicada
    ];
    mainProgram = "wps";
  };
in

stdenv.mkDerivation {
  inherit
    pname
    version
    src
    passthru
    meta
    ;

  nativeBuildInputs = [
    autoPatchelfHook
    makeShellWrapper
  ];

  buildInputs = [
    alsa-lib
    libjpeg
    libtool
    libxkbcommon
    nspr
    udev
    gtk3
    libgbm
    libusb1
    unixODBC
    libbsd
    libxxf86vm
    libpulseaudio
    libsForQt5.qtbase
    xorg.libXdamage
    xorg.libXtst
    xorg.libXv
    xorg.libXScrnSaver
  ];

  dontWrapQtApps = true;

  runtimeDependencies = map lib.getLib [
    cups
    dbus
    pango
  ];

  unpackPhase = ''
    # Unpack the .deb file
    ar x $src
    tar xf data.tar.xz

    # Remove unneeded files
    rm -rf usr/share/{fonts,locale,doc,templates}
    rm -f usr/bin/misc
    rm -rf opt/kingsoft/wps-office/{desktops,INSTALL,templates}
    rm -f opt/kingsoft/wps-office/office6/lib{peony-wpsprint-menu-plugin,bz2,jpeg,gcc_s,odbc*,dbus-1}.so*
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out

    cp -r opt $out
    cp -r usr/{bin,share} $out

    for i in et wpp wpspdf wps; do
      substituteInPlace $out/bin/$i \
        --replace-fail /opt/kingsoft/wps-office $out/opt/kingsoft/wps-office
    done

    for i in $out/share/applications/wps-office-*; do
      substituteInPlace $i \
        --replace-fail "Exec=/usr/bin/" "Exec="
    done

    makeShellWrapper $out/opt/xiezuo/xiezuo $out/bin/xiezuo \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ ]}" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true --wayland-text-input-version=3}}"

    sed -i 's|^Exec=.*$|Exec=xiezuo %U|' \
      $out/share/applications/xiezuo.desktop

    runHook postInstall
  '';

  preFixup = ''
    # dlopen dependency
    patchelf --add-needed libudev.so.1 $out/opt/kingsoft/wps-office/office6/addons/cef/libcef.so
    # libmysqlclient dependency
    patchelf --replace-needed libmysqlclient.so.18 libmysqlclient.so $out/opt/kingsoft/wps-office/office6/libFontWatermark.so
    patchelf --add-rpath ${libmysqlclient}/lib/mariadb $out/opt/kingsoft/wps-office/office6/libFontWatermark.so
    # fix et/wpp/wpspdf failure to launch with no mode configured
    for i in et wpp wpspdf wps; do
      substituteInPlace $out/bin/$i \
        --replace-fail '[ $haveConf -eq 1 ] &&' '[ ! $currentMode ] ||'
    done
  '';
}
