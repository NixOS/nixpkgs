{
  lib,
  stdenv,
  dpkg,
  autoPatchelfHook,
  alsa-lib,
  libtool,
  libxkbcommon,
  nspr,
  udev,
  gtk3,
  libgbm,
  libusb1,
  libsForQt5,
  xorg,
  cups,
  pango,
  bzip2,
  libmysqlclient,
  runCommandLocal,
  curl,
  coreutils,
  cacert,
}:

let
  pkgVersion = "12.1.2.22571";
  pkgSuffix = ".AK.preread.sw_480057_amd64.deb";
  url = "https://wps-linux-personal.wpscdn.cn/wps/download/ep/Linux2023/${lib.last (lib.splitVersion pkgVersion)}/wps-office_${pkgVersion}${pkgSuffix}";
  hash = "sha256-oppJqiUEe/0xEWxgKVMPMFngjQ0e5xaac6HuFVIBh8I=";
  uri = builtins.replaceStrings [ "https://wps-linux-personal.wpscdn.cn" ] [ "" ] url;
  securityKey = "7f8faaaa468174dc1c9cd62e5f218a5b";
in

stdenv.mkDerivation {
  pname = "wpsoffice-cn";
  version = pkgVersion;

  src =
    runCommandLocal "wps-office_${pkgVersion}${pkgSuffix}"
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
        md5hash=($(printf '%s' "${securityKey}${uri}$timestamp10" | md5sum))

        curl --retry 3 --retry-delay 3 "${url}?t=$timestamp10&k=$md5hash" > $out
      '';

  unpackCmd = "dpkg -x $src .";
  sourceRoot = ".";

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
  ];

  buildInputs = [
    alsa-lib
    libtool
    libxkbcommon
    nspr
    udev
    gtk3
    libgbm
    libusb1
    libsForQt5.qtbase
    xorg.libXdamage
    xorg.libXtst
    xorg.libXv
  ];

  dontWrapQtApps = true;

  runtimeDependencies = map lib.getLib [
    cups
    pango
  ];

  autoPatchelfIgnoreMissingDeps = [
    "libpeony.so.3"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out

    cp -r opt $out
    cp -r usr/{bin,share} $out

    for i in $out/bin/*; do
      substituteInPlace $i \
        --replace-fail /opt/kingsoft/wps-office $out/opt/kingsoft/wps-office
    done

    for i in $out/share/applications/*; do
      substituteInPlace $i \
        --replace-fail /usr/bin $out/bin
    done

    runHook postInstall
  '';

  preFixup = ''
    # libbz2 dangling symlink
    ln -sf ${bzip2.out}/lib/libbz2.so $out/opt/kingsoft/wps-office/office6/libbz2.so
    # dlopen dependency
    patchelf --add-needed libudev.so.1 $out/opt/kingsoft/wps-office/office6/addons/cef/libcef.so
    # libmysqlclient dependency
    patchelf --replace-needed libmysqlclient.so.18 libmysqlclient.so $out/opt/kingsoft/wps-office/office6/libFontWatermark.so
    patchelf --add-rpath ${libmysqlclient}/lib/mariadb $out/opt/kingsoft/wps-office/office6/libFontWatermark.so
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
