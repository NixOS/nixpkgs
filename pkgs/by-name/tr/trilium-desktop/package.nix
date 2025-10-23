{
  stdenv,
  lib,
  unzip,
  fetchurl,
  makeBinaryWrapper,
  # use specific electron since it has to load a compiled module
  electron_38,
  autoPatchelfHook,
  makeDesktopItem,
  copyDesktopItems,
  wrapGAppsHook3,
  asar,
}:

let
  pname = "trilium-desktop";
  version = "0.99.1";

  triliumSource = os: arch: hash: {
    url = "https://github.com/TriliumNext/Trilium/releases/download/v${version}/TriliumNotes-v${version}-${os}-${arch}.zip";
    inherit hash;
  };

  linuxSource = triliumSource "linux";
  darwinSource = triliumSource "macos";

  # exposed like this for update.sh
  x86_64-linux.hash = "sha256-cn1Y6wMYoVCuNNdAxesNKcZiRo2uKGV8nL6yK1KtNP8=";
  aarch64-linux.hash = "sha256-KhSSrdITpbGiIAEkdNfRAoIlhC2uUV6+8ZUaEYW7dyA=";
  x86_64-darwin.hash = "sha256-jKAZnCtNEEnvJ6p6lziOG7+uAyMuEel4dAKRXvMHo8c=";
  aarch64-darwin.hash = "sha256-1p0rUoZPunP3fRgn/EO3obdGp6l5BbsfZyKMlsgrl80=";

  sources = {
    x86_64-linux = linuxSource "x64" x86_64-linux.hash;
    aarch64-linux = linuxSource "arm64" aarch64-linux.hash;
    x86_64-darwin = darwinSource "x64" x86_64-darwin.hash;
    aarch64-darwin = darwinSource "arm64" aarch64-darwin.hash;
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
        desktopName = "Trilium Notes";
        categories = [ "Office" ];
        startupWMClass = "Trilium Notes";
      })
    ];

    installPhase = ''
      runHook preInstall
      mkdir -p "$out/bin"
      mkdir -p "$out/share/trilium"
      mkdir -p "$out/share/icons/hicolor/512x512/apps"

      cp -r ./* "$out/share/trilium/"
      rm $out/share/trilium/{*.so*,trilium,chrome_crashpad_handler,chrome-sandbox}

      # Rebuild the ASAR archive to patchelf native module.
      tmp=$(mktemp -d)
      asar extract $out/share/trilium/resources/app.asar $tmp
      rm $out/share/trilium/resources/app.asar

      autoPatchelf $tmp
      cp $tmp/public/assets/icon.png $out/share/icons/hicolor/512x512/apps/trilium.png

      asar pack $tmp/ $out/share/trilium/resources/app.asar
      rm -rf $tmp

      makeWrapper ${lib.getExe electron_38} $out/bin/trilium \
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
      mkdir -p "$out/Applications/Trilium Notes.app"
      cp -r * "$out/Applications/Trilium Notes.app/"
      runHook postInstall
    '';
  };

in
if stdenv.hostPlatform.isDarwin then darwin else linux
