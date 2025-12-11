{
  stdenv,
  lib,
  fetchurl,
  squashfsTools,
  autoPatchelfHook,
  copyDesktopItems,
  alsa-lib,
  nss,
  libdrm,
  libgbm,
  libGL,
  libxkbcommon,
  pcsclite,
  makeDesktopItem,
  makeWrapper,
  wrapGAppsHook3,
  writeScript,
  udev,
}:

stdenv.mkDerivation rec {
  pname = "tk-safe";
  version = "25.10.2";
  revision = "23";

  src = fetchurl {
    url = "https://api.snapcraft.io/api/v1/snaps/download/rLNeIGEaag0TKFQLO0TxF3ARXg3rcTNx_${revision}.snap";
    hash = "sha512-Al2SOS2X7FO7uuqB1iyZapYP+AJHVqRnPxzupt5N0TwfSCP+N3FgiKN32tzsROoff8hkmQt5En3hFCCh3/UePA==";
  };

  desktopItems = [
    (makeDesktopItem {
      name = "tk-safe";
      icon = "tk-safe";
      exec = "tk-safe";
      desktopName = "TK-Safe";
      comment = meta.description;
      genericName = "Eletronic medical record (ePA)";
      categories = [ "Utility" ];
    })
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    makeWrapper
    squashfsTools
    wrapGAppsHook3
  ];

  unpackPhase = ''
    runHook preUnpack

    unsquashfs $src

    runHook postUnpack
  '';

  sourceRoot = "squashfs-root";

  postPatch = ''
    rm -rf lib usr
  '';

  buildInputs = [
    alsa-lib
    nss
    libdrm
    libgbm
    libxkbcommon
    udev
    pcsclite
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,opt/tk-safe}
    mv * $out/opt/tk-safe
    ln -s $out/opt/tk-safe/app/tk-safe $out/bin/tk-safe

    mkdir -p $out/share/icons/hicolor/1024x1024/apps
    ln -s $out/opt/tk-safe/meta/gui/icon.png $out/share/icons/hicolor/1024x1024/apps/tk-safe.png

    runHook postInstall
  '';

  preFixup = ''
    wrapProgram $out/opt/tk-safe/app/tk-safe \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libGL ]}"
  '';

  passthru.updateScript = writeScript "update-tk-safe" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p common-updater-scripts curl jq

    set -eu -o pipefail

    data=$(curl -H 'X-Ubuntu-Series: 16' \
    'https://api.snapcraft.io/api/v1/snaps/details/tk-safe?fields=download_sha512,revision,version')

    version=$(jq -r .version <<<"$data")

    if [[ "x$UPDATE_NIX_OLD_VERSION" != "x$version" ]]; then

        revision=$(jq -r .revision <<<"$data")
        hash=$(nix --extra-experimental-features nix-command hash to-sri "sha512:$(jq -r .download_sha512 <<<"$data")")

        update-source-version "$UPDATE_NIX_ATTR_PATH" "$version" "$hash"
        update-source-version --ignore-same-hash --version-key=revision "$UPDATE_NIX_ATTR_PATH" "$revision" "$hash"

    fi
  '';

  meta = {
    description = "Electronic medical record (ePA) by Techniker Krankenkasse (TK)";
    homepage = "https://snapcraft.io/tk-safe";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    # Vendored copy of Electron.
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ felschr ];
    mainProgram = "tk-safe";
  };
}
