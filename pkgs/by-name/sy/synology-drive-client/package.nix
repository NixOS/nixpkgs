{
  stdenv,
  lib,
  writeScript,
  qt5,
  fetchurl,
  autoPatchelfHook,
  dpkg,
  glibc,
  cpio,
  xar,
  undmg,
  gtk3,
  pango,
  libxcb,
}:
let
  pname = "synology-drive-client";
  baseUrl = "https://global.synologydownload.com/download/Utility/SynologyDriveClient";
  version = "4.0.2-17889";
  buildNumberFn = ver: lib.last (lib.splitString "-" ver);
  meta = {
    description = "Desktop application to synchronize files and folders between the computer and the Synology Drive server";
    homepage = "https://www.synology.com/en-global/dsm/feature/drive";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      jcouyang
      MoritzBoehme
      nivalux
    ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    mainProgram = "synology-drive";
  };
  updateScript = ./update.sh;

  linux = stdenv.mkDerivation (finalAttrs: {
    inherit
      pname
      version
      meta
      ;

    src = fetchurl {
      url = "${baseUrl}/${finalAttrs.version}/Ubuntu/Installer/synology-drive-client-${buildNumberFn finalAttrs.version}.x86_64.deb";
      sha256 = "sha256-refsAzqYmKAr107D4HiJViBQE1Qa6QoOECtX+TPjSwU=";
    };

    nativeBuildInputs = [
      qt5.wrapQtAppsHook
      autoPatchelfHook
      dpkg
    ];

    buildInputs = [
      glibc
      gtk3
      pango
      libxcb
    ];

    unpackPhase = ''
      mkdir -p $out
      dpkg -x $src $out
      rm -rf $out/usr/lib/nautilus
      rm -rf $out/lib/x86_64-linux-gnu/nautilus
      rm -rf $out/usr/lib/x86_64-linux-gnu/nautilus

      find $out -name "libqpdf.so" -delete
      rm -rf $out/opt/Synology/SynologyDrive/package/cloudstation/icon-overlay
    '';

    installPhase = ''
      cp -av $out/usr/* $out
      rm -rf $out/usr
      runHook postInstall
    '';

    postInstall = ''
      substituteInPlace $out/bin/synology-drive --replace /opt $out/opt
    '';

    passthru = { inherit updateScript; };
  });

  darwin = stdenv.mkDerivation (finalAttrs: {
    inherit
      pname
      version
      meta
      ;

    src = fetchurl {
      url = "${baseUrl}/${finalAttrs.version}/Mac/Installer/synology-drive-client-${buildNumberFn finalAttrs.version}.dmg";
      sha256 = "sha256-KAoc31Y2RTHu7RWgC61brtoeFR1c+pNi4Odub2JHrfQ=";
    };

    nativeBuildInputs = [
      cpio
      xar
      undmg
    ];

    postUnpack = ''
      xar -xf 'Install Synology Drive Client.pkg'
      cd synology-drive.installer.pkg
      gunzip -dc Payload | cpio -i
    '';

    sourceRoot = ".";

    installPhase = ''
      mkdir -p $out/Applications/
      cp -R 'Synology Drive Client.app' $out/Applications/
    '';

    passthru = { inherit updateScript; };
  });
in
if stdenv.hostPlatform.isDarwin then darwin else linux
