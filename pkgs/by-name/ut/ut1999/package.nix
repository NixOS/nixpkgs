{ lib, stdenv, requireFile, autoPatchelfHook, fetchurl, makeDesktopItem, copyDesktopItems, imagemagick
, runCommand, libgcc, wxGTK32, innoextract, libGL, SDL2, openal, libmpg123, libxmp }:

let
  unpackGog = runCommand "ut1999-gog" {
    src = requireFile rec {
      name = "setup_ut_goty_2.0.0.5.exe";
      sha256 = "00v8jbqhgb1fry7jvr0i3mb5jscc19niigzjc989qrcp9pamghjc";
      message = ''
        Unreal Tournament 1999 requires the official GOG package, version 2.0.0.5.

        Once you download the file, run the following command:

        nix-prefetch-url file://\$PWD/${name}
      '';
    };

    buildInputs = [ innoextract ];
  } ''
    innoextract --extract --exclude-temp "$src"
    mkdir $out
    cp -r app/* $out
  '';
in stdenv.mkDerivation rec {
  name = "ut1999";
  version = "469d";
  sourceRoot = ".";
  src = fetchurl {
    url = "https://github.com/OldUnreal/UnrealTournamentPatches/releases/download/v${version}/OldUnreal-UTPatch${version}-Linux-amd64.tar.bz2";
    hash = "sha256-aoGzWuakwN/OL4+xUq8WEpd2c1rrNN/DkffI2vDVGjs=";
  };

  buildInputs = [
    libgcc
    wxGTK32
    SDL2
    libGL
    openal
    libmpg123
    libxmp
    stdenv.cc.cc
  ];

  nativeBuildInputs = [
    copyDesktopItems
    autoPatchelfHook
    imagemagick
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r ./* $out

    # Remove bundled libraries to use native versions instead
    rm $out/System64/libmpg123.so* \
      $out/System64/libopenal.so* \
      $out/System64/libSDL2* \
      $out/System64/libxmp.so*

    chmod -R 755 $out

    ln -s ${unpackGog}/Music $out
    ln -s ${unpackGog}/Sounds $out
    cp -n ${unpackGog}/Textures/* $out/Textures || true
    ln -s ${unpackGog}/Maps $out
    cp -n ${unpackGog}/System/*.{u,int} $out/System || true

    ln -s "$out/System64/ut-bin" "$out/bin/ut1999"
    ln -s "$out/System64/ucc-bin" "$out/bin/ut1999-ucc"

    convert "${unpackGog}/gfw_high.ico" "ut1999.png"
    install -D ut1999-5.png "$out/share/icons/hicolor/256x256/apps/ut1999.png"

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "ut1999";
      desktopName = "Unreal Tournament GOTY (1999)";
      exec = "ut1999";
      icon = "ut1999";
      comment = "Unreal Tournament GOTY (1999) with the OldUnreal patch.";
      categories = [ "Game" ];
    })
  ];

  meta = with lib; {
    description = "Unreal Tournament GOTY (1999) with the OldUnreal patch.";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ eliandoran ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "ut1999";
  };
}
