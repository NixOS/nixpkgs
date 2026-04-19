{
  lib,
  fetchzip,
  fetchurl,
  stdenvNoCC,
  makeDesktopItem,
  copyDesktopItems,
  autoPatchelfHook,
  wrapGAppsHook3,
  _7zz,
  glib,
  gsettings-desktop-schemas,
  libGL,
  libGLU,
  libgcc,
  gtk3,
  gtk2,
  libxxf86vm,
  libxtst,
  temurin-jre-bin,
}:

let
  pname = "vesta-viewer";
  version = "3.5.8";
  meta = {
    description = "3D visualization program for structural models, volumetric data such as electron/nuclear densities, and crystal morphologies";
    homepage = "https://jp-minerals.org/vesta/";
    license = lib.licenses.unfree;
    downloadPage = "https://jp-minerals.org/vesta/en/download.html";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
    ];
    maintainers = with lib.maintainers; [
      ulysseszhan
      layzyoldman
    ];
    mainProgram = "VESTA";
  };

  linuxArgs = {
    nativeBuildInputs = [
      copyDesktopItems
      autoPatchelfHook
      wrapGAppsHook3
    ];
    buildInputs = [
      glib
      gsettings-desktop-schemas
      libGL
      libGLU
      libgcc
      gtk3
      gtk2
      temurin-jre-bin
      libxxf86vm
      libxtst
    ];

    src = fetchzip {
      url = "https://jp-minerals.org/vesta/archives/${version}/VESTA-gtk3.tar.bz2";
      hash = "sha256-Dm4exMUgNZ6Sh8dVhsvLZGS38UXxe9t+9s3ttBQajGg=";
    };

    installPhase = ''
      runHook preInstall

      mkdir -p $out/lib/VESTA
      cp -r * $out/lib/VESTA

      mkdir -p $out/bin
      ln -s $out/lib/VESTA/VESTA{,-core,-gui} -t $out/bin

      # VESTA resolves resources (img/, *.ini, *.dat) relative to argv[0].
      # wrapProgram replaces the binary with a wrapper script, changing argv[0].
      # Symlinking data files into $out/bin/ ensures they are found correctly.
      for f in $out/lib/VESTA/*.ini $out/lib/VESTA/*.dat $out/lib/VESTA/asfdc; do
        ln -s $f $out/bin/$(basename $f)
      done

      ln -s $out/lib/VESTA/img $out/bin/img

      mkdir -p $out/share/icons/hicolor/{128x128,256x256}/apps
      ln -s $out/lib/VESTA/img/logo.png $out/share/icons/hicolor/128x128/apps/VESTA.png
      ln -s $out/lib/VESTA/img/logo@2x.png $out/share/icons/hicolor/256x256/apps/VESTA.png

      runHook postInstall
    '';

    desktopItems = [
      (makeDesktopItem {
        name = "vesta";
        comment = meta.description;
        desktopName = "VESTA";
        genericName = "VESTA";
        exec = "VESTA %u";
        icon = "VESTA";
        categories = [ "Science" ];
        mimeTypes = [
          "chemical/x-cif"
          "chemical/x-pdb"
          "chemical/x-xyz"
        ];
      })
    ];
  };

  darwinArgs = {
    nativeBuildInputs = [
      _7zz
    ];
    src = fetchurl {
      url = "https://jp-minerals.org/vesta/archives/${version}/VESTA.dmg";
      hash = "sha256-L8vj3MNwHo3m5wP1lByNjHZ4VTVOWSm0Aiw1ItosbSw=";
    };
    sourceRoot = "VESTA/VESTA";
    installPhase = ''
      runHook preInstall

      mkdir -p $out/Applications
      cp -r *.app $out/Applications

      runHook postInstall
    '';
  };
in
stdenvNoCC.mkDerivation (
  {
    inherit pname version meta;
    # I could've written an update script here,
    # but I didn't bother because the stable version hasn't been updated foryears.
  }
  // {
    "x86_64-linux" = linuxArgs;
    "x86_64-darwin" = darwinArgs;
  }
  .${stdenvNoCC.hostPlatform.system} or { }
)
