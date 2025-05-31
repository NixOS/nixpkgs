{
  lib,
  dpkg,
  stdenv,
  fetchurl,
  buildFHSEnv,
  autoPatchelfHook,
  writeShellScript,
  zenity,
  nss,
  gtk2,
  alsa-lib,
  dbus-glib,
  libXtst,
  libXdamage,
  libXScrnSaver,
}:

let
  sources = import ./sources.nix;

  xunlei-unwrapped = stdenv.mkDerivation rec {
    pname = "xunlei-uos";
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
        loongarch64-linux = fetchurl {
          url = sources.loongarch64_url;
          hash = sources.loongarch64_hash;
        };
      }
      .${stdenv.hostPlatform.system}
        or (throw "${pname}-${version}: ${stdenv.hostPlatform.system} is unsupported.");

    buildInputs = [
      nss
      gtk2
      alsa-lib
      dbus-glib
      libXtst
      libXdamage
      libXScrnSaver
    ];

    nativeBuildInputs = [
      dpkg
      autoPatchelfHook
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/lib
      cp -r opt/apps/com.xunlei.download/files $out/lib/xunlei
      cp -r opt/apps/com.xunlei.download/entries $out/share
      mv $out/share/icons/hicolor/scalable/apps/com.thunder.download.svg \
        $out/share/icons/hicolor/scalable/apps/com.xunlei.download.svg
      substituteInPlace $out/share/applications/com.xunlei.download.desktop \
        --replace-fail "Categories=net" "Categories=Network" \
        --replace-fail "/opt/apps/com.xunlei.download/files/start.sh" "xunlei-uos" \
        --replace-fail "/opt/apps/com.xunlei.download/entries/icons/hicolor/256x256/apps/com.xunlei.download.png" "com.xunlei.download"

      runHook postInstall
    '';

    meta = {
      description = "Download manager supporting HTTP, FTP, BitTorrent, and eDonkey network protocols";
      homepage = "https://www.xunlei.com";
      license = lib.licenses.unfree;
      maintainers = [ lib.maintainers.linuxwhata ];
      platforms = [
        "x86_64-linux"
        "aarch64-linux"
        "loongarch64-linux"
      ];
    };
  };
in
buildFHSEnv {
  inherit (xunlei-unwrapped) pname version meta;
  runScript = writeShellScript "xunlei-launcher" ''
    exec ${xunlei-unwrapped}/lib/xunlei/thunder -start $1 "$@"
  '';
  extraInstallCommands = ''
    mkdir -p $out
    ln -s ${xunlei-unwrapped}/share $out/share
  '';

  passthru.updateScript = ./update.sh;

  includeClosures = true;
  targetPkgs = pkgs: [ zenity ]; # system tray click events
}
