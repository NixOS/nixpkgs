{
  stdenv,
  lib,
  unzip,
  fetchurl,
  makeBinaryWrapper,
  # use specific electron since it has to load a compiled module
  electron_34,
  autoPatchelfHook,
  makeDesktopItem,
  copyDesktopItems,
  wrapGAppsHook3,
  asar,
}:

let
  pname = "trilium-next-desktop";
  version = "0.92.6";

  triliumSource = os: arch: sha256: {
    url = "https://github.com/TriliumNext/Notes/releases/download/v${version}/TriliumNextNotes-v${version}-${os}-${arch}.zip";
    inherit sha256;
  };

  linuxSource = triliumSource "linux";
  darwinSource = triliumSource "macos";

  # exposed like this for update.sh
  x86_64-linux.sha256 = "1ky5w6iwqcsc66ywgamkfs9yd6bp51c3y69251pi4b365dwbglf5";
  aarch64-linux.sha256 = "1zm6g2rkg31ahnn8y5h42vb632pqjg6d8kb4xkkrb4pp9h71sgjm";
  x86_64-darwin.sha256 = "011y5vh0bfn73l8n4my5pdpgrvvicy1lvnjrb1qyaglg7gw2sy0r";
  aarch64-darwin.sha256 = "05v6pk1h5y5kqwjkixji3a44dcr219320z0i6yvwv4d8mc943qhs";

  sources = {
    x86_64-linux = linuxSource "x64" x86_64-linux.sha256;
    aarch64-linux = linuxSource "arm64" aarch64-linux.sha256;
    x86_64-darwin = darwinSource "x64" x86_64-darwin.sha256;
    aarch64-darwin = darwinSource "arm64" aarch64-darwin.sha256;
  };

  src = fetchurl sources.${stdenv.hostPlatform.system};

  meta = {
    description = "Hierarchical note taking application with focus on building large personal knowledge bases";
    homepage = "https://github.com/TriliumNext/Notes";
    license = lib.licenses.agpl3Plus;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [
      eliandoran
      fliegendewurst
    ];
    mainProgram = "trilium";
    platforms = lib.attrNames sources;
  };

  linux = stdenv.mkDerivation {
    inherit
      pname
      version
      meta
      src
      ;

    # Remove trilium-portable.sh, so trilium knows it is packaged making it stop auto generating a desktop item on launch
    postPatch = ''
      rm ./trilium-portable.sh
    '';

    nativeBuildInputs = [
      unzip
      makeBinaryWrapper
      wrapGAppsHook3
      copyDesktopItems
      autoPatchelfHook
      asar
    ];

    buildInputs = [
      (lib.getLib stdenv.cc.cc)
    ];

    desktopItems = [
      (makeDesktopItem {
        name = "Trilium";
        exec = "trilium";
        icon = "trilium";
        comment = meta.description;
        desktopName = "TriliumNext Notes";
        categories = [ "Office" ];
        startupWMClass = "Trilium Notes Next";
      })
    ];

    installPhase = ''
      runHook preInstall
      mkdir -p "$out/bin"
      mkdir -p "$out/share/trilium"
      mkdir -p "$out/share/icons/hicolor/512x512/apps"

      cp -r ./* "$out/share/trilium/"
      rm $out/share/trilium/{*.so*,trilium,chrome_crashpad_handler,chrome-sandbox}

      # Rebuild the ASAR archive, hardcoding the resourcesPath
      tmp=$(mktemp -d)
      asar extract $out/share/trilium/resources/app.asar $tmp
      rm $out/share/trilium/resources/app.asar

      for f in "src/services/utils.js"; do
        substituteInPlace $tmp/$f \
          --replace-fail "process.resourcesPath" "'$out/share/trilium/resources'"
      done
      autoPatchelf $tmp
      cp $tmp/src/public/icon.png $out/share/icons/hicolor/512x512/apps/trilium.png

      asar pack $tmp/ $out/share/trilium/resources/app.asar
      rm -rf $tmp

      makeWrapper ${lib.getExe electron_34} $out/bin/trilium \
        "''${gappsWrapperArgs[@]}" \
        --set-default ELECTRON_IS_DEV 0 \
        --add-flags $out/share/trilium/resources/app.asar

      runHook postInstall
    '';

    dontWrapGApps = true;

    passthru.updateScript = ./update.sh;
  };

  darwin = stdenv.mkDerivation {
    inherit
      pname
      version
      meta
      src
      ;

    nativeBuildInputs = [
      unzip
    ];

    installPhase = ''
      runHook preInstall
      mkdir -p "$out/Applications/TriliumNext Notes.app"
      cp -r * "$out/Applications/TriliumNext Notes.app/"
      runHook postInstall
    '';
  };

in
if stdenv.hostPlatform.isDarwin then darwin else linux
