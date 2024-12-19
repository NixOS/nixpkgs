{
  lib,
  stdenv,
  requireFile,
  autoPatchelfHook,
  undmg,
  fetchurl,
  makeDesktopItem,
  copyDesktopItems,
  libarchive,
  imagemagick,
  runCommand,
  libgcc,
  wxGTK32,
  libGL,
  SDL2,
  openal,
  libmpg123,
  libxmp,
}:

let
  version = "469d";
  srcs = {
    x86_64-linux = fetchurl {
      url = "https://github.com/OldUnreal/UnrealTournamentPatches/releases/download/v${version}/OldUnreal-UTPatch${version}-Linux-amd64.tar.bz2";
      hash = "sha256-aoGzWuakwN/OL4+xUq8WEpd2c1rrNN/DkffI2vDVGjs=";
    };
    aarch64-linux = fetchurl {
      url = "https://github.com/OldUnreal/UnrealTournamentPatches/releases/download/v${version}/OldUnreal-UTPatch${version}-Linux-arm64.tar.bz2";
      hash = "sha256-2e9lHB12jLTR8UYofLWL7gg0qb2IqFk6eND3T5VqAx0=";
    };
    i686-linux = fetchurl {
      url = "https://github.com/OldUnreal/UnrealTournamentPatches/releases/download/v${version}/OldUnreal-UTPatch${version}-Linux-x86.tar.bz2";
      hash = "sha256-1JsFKuAAj/LtYvOUPFu0Hn+zvY3riW0YlJbLd4UnaKU=";
    };
    x86_64-darwin = fetchurl {
      url = "https://github.com/OldUnreal/UnrealTournamentPatches/releases/download/v${version}/OldUnreal-UTPatch${version}-macOS-Sonoma.dmg";
      hash = "sha256-TbhJbOH4E5WOb6XR9dmqLkXziK3/CzhNjd1ypBkkmvw=";
    };
  };
  unpackIso =
    runCommand "ut1999-iso"
      {
        src = fetchurl {
          url = "https://archive.org/download/ut-goty/UT_GOTY_CD1.iso";
          hash = "sha256-4YSYTKiPABxd3VIDXXbNZOJm4mx0l1Fhte1yNmx0cE8=";
        };
        nativeBuildInputs = [ libarchive ];
      }
      ''
        bsdtar -xvf "$src"
        mkdir $out
        cp -r Music Sounds Textures Maps $out
      '';
  systemDir =
    {
      x86_64-linux = "System64";
      aarch64-linux = "SystemARM64";
      x86_64-darwin = "System";
      i686-linux = "System";
    }
    .${stdenv.hostPlatform.system} or (throw "unsupported system: ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation {
  name = "ut1999";
  inherit version;
  sourceRoot = ".";
  src =
    srcs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

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

  nativeBuildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      copyDesktopItems
      autoPatchelfHook
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      undmg
    ];

  installPhase =
    let
      outPrefix =
        if stdenv.hostPlatform.isDarwin then "$out/UnrealTournament.app/Contents/MacOS" else "$out";
    in
    ''
      runHook preInstall

      mkdir -p $out/bin
      cp -r ${if stdenv.hostPlatform.isDarwin then "UnrealTournament.app" else "./*"} $out
      chmod -R 755 $out
      cd ${outPrefix}

      # NOTE: OldUnreal patch doesn't include these folders but could in the future
      rm -rf ./{Music,Sounds,Maps}
      ln -s ${unpackIso}/{Music,Sounds,Maps} .

      # TODO: unpack compressed maps with ucc

      cp -n ${unpackIso}/Textures/* ./Textures || true
      cp -n ${unpackIso}/System/*.{u,int} ./System || true
    ''
    + lib.optionalString (stdenv.hostPlatform.isLinux) ''
      ln -s "$out/${systemDir}/ut-bin" "$out/bin/ut1999"
      ln -s "$out/${systemDir}/ucc-bin" "$out/bin/ut1999-ucc"

      install -D "${./ut1999.svg}" "$out/share/pixmaps/ut1999.svg"
      ${imagemagick}/bin/magick -background none ${./ut1999.svg} -resize 16x16 ut1999_16x16.png
      ${imagemagick}/bin/magick -background none ${./ut1999.svg} -resize 24x24 ut1999_24x24.png
      ${imagemagick}/bin/magick -background none ${./ut1999.svg} -resize 32x32 ut1999_32x32.png
      ${imagemagick}/bin/magick -background none ${./ut1999.svg} -resize 48x48 ut1999_48x48.png
      ${imagemagick}/bin/magick -background none ${./ut1999.svg} -resize 64x64 ut1999_64x64.png
      ${imagemagick}/bin/magick -background none ${./ut1999.svg} -resize 128x128 ut1999_128x128.png
      ${imagemagick}/bin/magick -background none ${./ut1999.svg} -resize 192x192 ut1999_192x192.png
      ${imagemagick}/bin/magick -background none ${./ut1999.svg} -resize 256x256 ut1999_256x256.png
      install -D "ut1999_16x16.png" "$out/share/icons/hicolor/16x16/apps/ut1999.png"
      install -D "ut1999_24x24.png" "$out/share/icons/hicolor/24x24/apps/ut1999.png"
      install -D "ut1999_32x32.png" "$out/share/icons/hicolor/32x32/apps/ut1999.png"
      install -D "ut1999_48x48.png" "$out/share/icons/hicolor/48x48/apps/ut1999.png"
      install -D "ut1999_64x64.png" "$out/share/icons/hicolor/64x64/apps/ut1999.png"
      install -D "ut1999_128x128.png" "$out/share/icons/hicolor/128x128/apps/ut1999.png"
      install -D "ut1999_192x192.png" "$out/share/icons/hicolor/192x192/apps/ut1999.png"
      install -D "ut1999_256x256.png" "$out/share/icons/hicolor/256x256/apps/ut1999.png"

      # Remove bundled libraries to use native versions instead
      rm $out/${systemDir}/libmpg123.so* \
        $out/${systemDir}/libopenal.so* \
        $out/${systemDir}/libSDL2* \
        $out/${systemDir}/libxmp.so*
        # NOTE: what about fmod?
        #$out/${systemDir}/libfmod.so*
    ''
    + ''
      runHook postInstall
    '';

  # Bring in game's .so files into lookup. Otherwise game fails to start
  # as: `Object not found: Class Render.Render`
  appendRunpaths = [
    "${placeholder "out"}/${systemDir}"
  ];

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
    description = "Unreal Tournament GOTY (1999) with the OldUnreal patch";
    license = licenses.unfree;
    platforms = attrNames srcs;
    maintainers = with maintainers; [ eliandoran ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    mainProgram = "ut1999";
  };
}
