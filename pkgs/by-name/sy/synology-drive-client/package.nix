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
  version = "4.0.1-17885";
  buildNumber = lib.last (lib.splitString "-" version);
  meta = {
    description = "Desktop application to synchronize files and folders between the computer and the Synology Drive server";
    homepage = "https://www.synology.com/en-global/dsm/feature/drive";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      jcouyang
      MoritzBoehme
    ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    mainProgram = "synology-drive";
  };
  passthru.updateScript = writeScript "update-synology-drive-client" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl jq common-updater-scripts

    set -eu -o pipefail

    version=$(curl -s "https://www.synology.com/api/releaseNote/findChangeLog?identify=SynologyDriveClient&lang=en-uk" \
              | jq -r '.info.versions | to_entries | .[0].value.all_versions[0].version')

    if [[ "$version" =~ ^[0-9.]+(-[0-9]+)?$ ]]; then
      update-source-version synology-drive-client "$version"
    else
      echo "Error: Invalid version format: '$version'"
      exit 1
    fi
  '';

  linux = stdenv.mkDerivation {
    inherit
      pname
      version
      meta
      passthru
      ;

    src = fetchurl {
      url = "${baseUrl}/${version}/Ubuntu/Installer/synology-drive-client-${buildNumber}.x86_64.deb";
      sha256 = "sha256-DMHqh8o0RknWTycANSbMpJj133/MZ8uZ18ytDZVaKMg=";
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
  };

  darwin = stdenv.mkDerivation {
    inherit
      pname
      version
      meta
      passthru
      ;

    src = fetchurl {
      url = "${baseUrl}/${version}/Mac/Installer/synology-drive-client-${buildNumber}.dmg";
      sha256 = "sha256-0rK7w4/RCv4qml+8XYPwLQmxHen3pB793Co4DvnDVuU=";
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
  };
in
if stdenv.hostPlatform.isDarwin then darwin else linux
