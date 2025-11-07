{
  lib,
  stdenv,
  fetchzip,
  fetchurl,
  makeDesktopItem,

  copyDesktopItems,
  makeWrapper,
  wine,
  winetricks,
}:

stdenv.mkDerivation rec {
  pname = "vtfedit";
  version = "1.3.3";

  src = fetchzip {
    url = "https://nemstools.github.io/files/vtfedit${lib.replaceStrings [ "." ] [ "" ] version}.zip";
    hash = "sha256-6a8YuxgYm7FB+2pFcZAMtE1db4hqpEk0z5gv2wHl9bI=";
    stripRoot = false;
  };

  icon = fetchurl {
    url = "https://web.archive.org/web/20230906220249im_/https://valvedev.info/tools/vtfedit/thumb.png";
    hash = "sha256-Jpqo/s1wO2U5Z1DSZvADTfdH+8ycr0KF6otQbAE+jts=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
  ];

  nativeRuntimeInputs = lib.makeBinPath [
    wine
    winetricks
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/share/icons/hicolor/256x256/apps
    mkdir -p $out/share/lib
    mkdir -p $out/share/mime/packages

    substitute ${./vtfedit.bash} $out/bin/vtfedit \
      --replace-fail "@out@" "${placeholder "out"}" \
      --replace-fail "@path@" "${nativeRuntimeInputs}"
    chmod +x $out/bin/vtfedit

    cp ${icon} $out/share/icons/hicolor/256x256/apps/vtfedit.png
    cp -r ${if wine.meta.mainProgram == "wine64" then "x64" else "x86"}/* $out/share/lib
    cp ${./mimetype.xml} $out/share/mime/packages/vtfedit.xml

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      desktopName = "VTFEdit";
      exec = "vtfedit %f";
      icon = "vtfedit";
      terminal = false;
      categories = [ "Graphics" ];
      comment = meta.description;
      mimeTypes = [ "application/x-vtfedit" ];
    })
  ];

  meta = {
    description = "VTF file viewer/editor";
    homepage = "https://nemstools.github.io/pages/VTFLib.html";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.lgpl21Plus;
    inherit (wine.meta) platforms;
    maintainers = [ ];
  };
}
