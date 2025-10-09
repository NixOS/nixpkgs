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
  udev,
}:

stdenv.mkDerivation rec {
  pname = "tk-safe";
  version = "25.8.2";

  # To update, check https://search.apps.ubuntu.com/api/v1/package/tk-safe and copy the anon_download_url and version.
  src = fetchurl {
    url = "https://api.snapcraft.io/api/v1/snaps/download/rLNeIGEaag0TKFQLO0TxF3ARXg3rcTNx_19.snap";
    hash = "sha256-bjlkLCTHkGH2LdeGd3LIp7L8f7SzZetpEpvGpPEzjcA=";
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
