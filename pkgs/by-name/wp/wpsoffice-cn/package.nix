{
  lib,
  stdenv,
  fetchurl,
  undmg,
  autoPatchelfHook,
  runCommandLocal,
  curl,
  coreutils,
  cacert,
  # wpsoffice dependencies
  alsa-lib,
  libjpeg,
  libtool,
  libxkbcommon,
  nss,
  nspr,
  udev,
  gtk3,
  libgbm,
  libusb1,
  unixODBC,
  libmysqlclient,
  libsForQt5,
  xorg,
  # wpsoffice runtime dependencies
  cups,
  dbus,
  pango,
}:

let
  pname = "wpsoffice-cn";
  sources = import ./sources.nix;
  version = if stdenv.hostPlatform.isDarwin then sources.darwin-version else sources.linux-version;

  fetch =
    if stdenv.hostPlatform.isDarwin then
      fetchurl
    else
      {
        url,
        hash,
      }:
      runCommandLocal "wpsoffice-cn-${version}.deb"
        {
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
          readonly SECURITY_KEY="7f8faaaa468174dc1c9cd62e5f218a5b"

          timestamp10=$(date '+%s')
          md5hash=($(printf '%s' "$SECURITY_KEY${lib.removePrefix "https://wps-linux-personal.wpscdn.cn" url}$timestamp10" | md5sum))

          curl --retry 3 --retry-delay 3 "${url}?t=$timestamp10&k=$md5hash" > $out
        '';

  src =
    fetch
      sources.${stdenv.hostPlatform.system}
        or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  passthru = {
    updateScript = ./update.sh;
  };

  meta = {
    description = "Office suite, formerly Kingsoft Office";
    homepage = "https://www.wps.cn";
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
      "x86_64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    hydraPlatforms = [ ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      mlatus
      th0rgal
      wineee
      pokon548
      chillcicada
    ];
  }
  // lib.optionalAttrs stdenv.hostPlatform.isLinux {
    changelog = "https://linux.wps.cn/wpslinuxlog";
    mainProgram = "wps";
  };
in

if stdenv.hostPlatform.isDarwin then
  stdenv.mkDerivation {
    inherit
      pname
      version
      src
      passthru
      meta
      ;

    nativeBuildInputs = [ undmg ];
    sourceRoot = ".";

    installPhase = ''
      runHook preInstall

      mkdir -p $out/Applications
      cp -a wpsoffice.app $out/Applications

      runHook postInstall
    '';
  }

else
  stdenv.mkDerivation {
    inherit
      pname
      version
      src
      passthru
      meta
      ;

    nativeBuildInputs = [ autoPatchelfHook ];

    buildInputs = [
      alsa-lib
      libjpeg
      libtool
      libxkbcommon
      nss
      nspr
      udev
      gtk3
      libgbm
      libusb1
      unixODBC
      libsForQt5.qtbase
      xorg.libXdamage
      xorg.libXtst
      xorg.libXv
    ];

    dontWrapQtApps = true;

    stripAllList = [ "opt" ];

    runtimeDependencies = map lib.getLib [
      cups
      dbus
      pango
    ];

    unpackPhase = ''
      # Unpack the .deb file
      ar x $src
      tar -xf data.tar.xz

      # Remove unneeded files
      rm -rf usr/share/{fonts,locale}
      rm -f usr/bin/misc
      rm -rf opt/kingsoft/wps-office/{desktops,INSTALL}
      rm -f opt/kingsoft/wps-office/office6/lib{peony-wpsprint-menu-plugin,bz2,jpeg,stdc++,gcc_s,odbc*,nss*,dbus-1}.so*
    '';

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
      # dlopen dependency
      patchelf --add-needed libudev.so.1 $out/opt/kingsoft/wps-office/office6/addons/cef/libcef.so
      # libmysqlclient dependency
      patchelf --replace-needed libmysqlclient.so.18 libmysqlclient.so $out/opt/kingsoft/wps-office/office6/libFontWatermark.so
      patchelf --add-rpath ${libmysqlclient}/lib/mariadb $out/opt/kingsoft/wps-office/office6/libFontWatermark.so
      # fix et/wpp/wpspdf failure to launch with no mode configured
      for i in $out/bin/*; do
        substituteInPlace $i \
          --replace-fail '[ $haveConf -eq 1 ] &&' '[ ! $currentMode ] ||'
      done
    '';
  }
