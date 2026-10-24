{
  lib,
  stdenv,
  fetchurl,
  asar,
  autoPatchelfHook,
  makeWrapper,
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
  unixodbc,
  libbsd,
  libxxf86vm,
  libpulseaudio,
  libsForQt5,
  libxdamage,
  libxtst,
  libxv,
  libxscrnsaver,
  libmysqlclient,
  # xiezuo dependencies
  ffmpeg,
  electron,
  lld,
  busybox,
  lsb-release,
  # wpsoffice runtime dependencies
  cups,
  dbus,
  pango,
  # other
  withFonts ? true,
}:

let
  pname = "wpsoffice-365";
  version = "12.1.2.26885";

  passthru = {
    sources = {
      x86_64-linux = fetchurl {
        name = "wpsoffice-365-${version}.deb";
        url = "https://pubwps-wps365-obs.wpscdn.cn/download/Linux/26885/wps-office_12.1.2.26885.AK.preread.sw.365_715978_amd64.deb";
        hash = "sha256-vRmkFdG467YefYs3/QZ+0+D63d+tVWpfQF40F1DBQAU=";
      };
      aarch64-linux = fetchurl {
        name = "wpsoffice-365-${version}.deb";
        url = "https://pubwps-wps365-obs.wpscdn.cn/download/Linux/26885/wps-office_12.1.2.26885.AK.preread.sw.365_715982_arm64.deb";
        hash = "sha256-MF3bbbfJH/pbayn7JxFy6Bew43uUH6AR+6uKc6go9JU=";
      };
      loongarch64-linux = fetchurl {
        name = "wpsoffice-365-${version}.deb";
        url = "https://pubwps-wps365-obs.wpscdn.cn/download/Linux/26885/wps-office_12.1.2.26885.AK.preread.sw.365_715977_loongarch64.deb";
        hash = "sha256-T0OSUVzhj70PbK8tyxbovVM6b1wK2q82AWZjTNrNETQ=";
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

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    asar
    autoPatchelfHook
    makeWrapper
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
    unixodbc
    libbsd
    libxxf86vm
    libpulseaudio
    libsForQt5.qtbase
    libxdamage
    libxtst
    libxv
    libxscrnsaver
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
    rm -rf usr/share/{locale,doc,templates}
    rm -f usr/bin/misc
    rm -rf opt/kingsoft/wps-office/{desktops,INSTALL,templates}
    rm -f opt/kingsoft/wps-office/office6/lib{peony-wpsprint-menu-plugin,bz2,jpeg,gcc_s,odbc*,dbus-1}.so*

    ${lib.optionalString (!withFonts) ''
      rm -rf opt/kingsoft/wps-office/office6/fonts
    ''}
  '';

  postPatch = ''
    patchShebangs usr/bin

    # Repack app.asar
    pushd opt/xiezuo/resources
    asar e app.asar app
    rm -rf {app.asar,ffmpeg}
    rm -f **/libstdc++.so*
    find app/dist -type f -name "*.js" -exec \
      sed -i "s#process\.resourcesPath#'$out/opt/xiezuo/resources'#g" {} \;
    substituteInPlace app/node_modules/@kmt/desktop/dist/preload/utils.js \
      --replace-fail "process.resourcesPath" "'$out/opt/xiezuo/resources'"
    substituteInPlace app/dist/wns-netdiag-child.js \
      --replace-fail ", logger: silentLogger" ""
    substituteInPlace app/node_modules/degenerator/dist/src/index.js \
      --replace-fail "util_1.isRegExp(n)" "Object.prototype.toString.call(n) === '[object RegExp]'"
    asar p app app.asar
    rm -rf app
    popd
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/xiezuo

    cp -r opt/kingsoft $out/opt
    cp -r usr/{bin,share} $out

    cp -r opt/xiezuo/{_icons,locales,nss,resources{,.pak},lib{nss{,util},smime,ssl}3.so} $out/opt/xiezuo

    mkdir -p $out/opt/xiezuo/resources/ffmpeg
    ln -s ${lib.getExe' ffmpeg "ffmpeg"} $out/opt/xiezuo/resources/ffmpeg/ffmpeg

    for i in et wpp wpspdf wps; do
      substituteInPlace $out/bin/$i \
        --replace-fail /opt/kingsoft/wps-office $out/opt/kingsoft/wps-office
    done

    for i in $out/share/applications/wps-office-*; do
      substituteInPlace $i \
        --replace-fail "/usr/bin/" ""
    done

    makeWrapper '${lib.getExe electron}' $out/bin/xiezuo \
      --prefix PATH : ${
        lib.makeBinPath [
          lld
          busybox
          lsb-release
        ]
      } \
      --add-flags $out/opt/xiezuo/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true --wayland-text-input-version=3}}" \
      --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
      --set-default ELECTRON_IS_DEV 0 \
      --inherit-argv0

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
  '';
}
