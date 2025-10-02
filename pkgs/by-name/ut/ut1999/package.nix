{
  lib,
  stdenv,
  requireFile,
  autoPatchelfHook,
  undmg,
  fetchurl,
  makeDesktopItem,
  makeWrapper,
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
  version = "469e-rc9";
  srcs = rec {
    x86_64-linux = fetchurl {
      url = "https://github.com/OldUnreal/UnrealTournamentPatches/releases/download/v${version}/OldUnreal-UTPatch${builtins.elemAt (lib.strings.splitString "-" version) 0}-Linux-amd64.tar.bz2";
      hash = "sha256-1hEWiUjgzb1mKTs/2p2/Whj8FdpqpvfaDtXf63S/W44=";
    };
    aarch64-linux = fetchurl {
      url = "https://github.com/OldUnreal/UnrealTournamentPatches/releases/download/v${version}/OldUnreal-UTPatch${builtins.elemAt (lib.strings.splitString "-" version) 0}-Linux-arm64.tar.bz2";
      hash = "sha256-ZYbwwefn5ifzz9rkx9X8PSVy1c8t2Z24VXt6dignUtg=";
    };
    i686-linux = fetchurl {
      url = "https://github.com/OldUnreal/UnrealTournamentPatches/releases/download/v${version}/OldUnreal-UTPatch${builtins.elemAt (lib.strings.splitString "-" version) 0}-Linux-x86.tar.bz2";
      hash = "sha256-afpDtlU01tEpGnfgichWqsUj80Lk2K//s/6iyqS/Vq8=";
    };
    x86_64-darwin = fetchurl {
      url = "https://github.com/OldUnreal/UnrealTournamentPatches/releases/download/v${version}/OldUnreal-UTPatch${builtins.elemAt (lib.strings.splitString "-" version) 0}-macOS.dmg";
      hash = "sha256-rFbgSQNeYwgd3Dzs/F+ljUFaGRwHCddLEuJBCehKktQ=";
    };
    # fat binary
    aarch64-darwin = x86_64-darwin;
  };
  unpackIso =
    runCommand "ut1999-iso"
      {
        # This upload of the game is officially sanctioned by OldUnreal (who has received permission from Epic Games to link to archive.org) and the UT99.org community
        # This is a copy of the original Unreal Tournament: Game of the Year Edition (also known as UT or UT99).
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
    rec {
      x86_64-linux = "System64";
      aarch64-linux = "SystemARM64";
      i686-linux = "System";
      x86_64-darwin = "System";
      aarch64-darwin = x86_64-darwin;
    }
    .${stdenv.hostPlatform.system} or (throw "unsupported system: ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation (finalAttrs: {
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
      makeWrapper
      undmg
    ];

  installPhase =
    let
      outPrefix =
        if stdenv.hostPlatform.isDarwin then
          "$out/Applications/UnrealTournament.app/Contents/MacOS"
        else
          "$out";
    in
    ''
      runHook preInstall
      mkdir -p $out/bin
    ''
    + lib.optionalString (stdenv.hostPlatform.isLinux) ''
      cp -r ./* $out
    ''
    + lib.optionalString (stdenv.hostPlatform.isDarwin) ''
      mkdir -p $out/Applications/
      cp -r "UnrealTournament.app" $out/Applications/
      makeWrapper $out/Applications/UnrealTournament.app/Contents/MacOS/UnrealTournament \
        $out/bin/${finalAttrs.meta.mainProgram}
    ''
    + ''
      chmod -R 755 $out
      cd ${outPrefix}
      # NOTE: OldUnreal patch doesn't include these folders on linux but could in the future
      # on darwin it does, but they are empty
      rm -rf ./{Music,Sounds}
      ln -s ${unpackIso}/{Music,Sounds} .
    ''
    + lib.optionalString (stdenv.hostPlatform.isLinux) ''
      # maps need no post-processing on linux, therefore linking them is ok
      rm -rf ./Maps
      ln -s ${unpackIso}/Maps .
    ''
    + lib.optionalString (stdenv.hostPlatform.isDarwin) ''
      # Maps need post-processing on darwin, therefore need to be copied
      cp -n ${unpackIso}/Maps/* ./Maps || true
      # unpack compressed maps with ucc (needs absolute paths)
      for map in $PWD/Maps/*.uz; do ./UCC decompress $map; done
      mv ${systemDir}/*.unr ./Maps || true
      rm ./Maps/*.uz
    ''
    + ''
      cp -n ${unpackIso}/Textures/* ./Textures || true
    ''
    + lib.optionalString (stdenv.hostPlatform.isLinux) ''
      cp -n ${unpackIso}/System/*.{u,int} ./System || true
      ln -s "$out/${systemDir}/ut-bin" "$out/bin/ut1999"
      ln -s "$out/${systemDir}/ucc-bin" "$out/bin/ut1999-ucc"

      install -D "${./ut1999.svg}" "$out/share/pixmaps/ut1999.svg"
      for size in 16 24 32 48 64 128 192 256; do
        square=$(printf "%sx%s" $size $size)
        ${imagemagick}/bin/magick -background none ${./ut1999.svg} -resize $square ut1999_$square.png
        install -D "ut1999_$square.png" "$out/share/icons/hicolor/$square/apps/ut1999.png"
      done

      # TODO consider to remove shared libraries that can be provided by nixpkgs for darwin too
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

  # This can be removed with version 469e as that contains this file already
  # Workaround for bug https://github.com/OldUnreal/UnrealTournamentPatches/issues/1578
  # that prevented starting or joining a multi player game
  missing-file = fetchurl {
    url = "https://gist.github.com/dwt/733d620fbbfd5c49da88683aef60d889/raw/73b271ef019412cf1be5ce1966842ef63a18ba39/de.u";
    hash = "sha256-M14imMl35KUT0tG8dgB+DBoXve/1saVL7hPNgUFo1hY=";
  };
  postInstall = lib.optionalString (stdenv.hostPlatform.isDarwin) ''
    cp ${finalAttrs.missing-file} $out/Applications/UnrealTournament.app/Contents/MacOS/System/de.u
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
    maintainers = with maintainers; [
      eliandoran
      dwt
    ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    mainProgram = "ut1999";
  };
})
