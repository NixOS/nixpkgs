{
  lib,
  stdenv,
  requireFile,
  autoPatchelfHook,
  undmg,
  fetchurl,
  makeDesktopItem,
  copyDesktopItems,
  imagemagick,
  runCommand,
  libgcc,
  wxGTK32,
  innoextract,
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
  unpackGog =
    runCommand "ut1999-gog"
      {
        src = requireFile rec {
          name = "setup_ut_goty_2.0.0.5.exe";
          sha256 = "00v8jbqhgb1fry7jvr0i3mb5jscc19niigzjc989qrcp9pamghjc";
          message = ''
            Unreal Tournament 1999 requires the official GOG package, version 2.0.0.5.

            Once you download the file, run the following command:

            nix-prefetch-url file://\$PWD/${name}
          '';
        };

        nativeBuildInputs = [ innoextract ];
      }
      ''
        innoextract --extract --exclude-temp "$src"
        mkdir $out
        cp -r app/* $out
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
    lib.optionals stdenv.isLinux [
      copyDesktopItems
      autoPatchelfHook
      imagemagick
    ]
    ++ lib.optionals stdenv.isDarwin [
      undmg
    ];

  installPhase =
    let
      outPrefix = if stdenv.isDarwin then "$out/UnrealTournament.app/Contents/MacOS" else "$out";
    in
    ''
      runHook preInstall

      mkdir -p $out/bin
      cp -r ${if stdenv.isDarwin then "UnrealTournament.app" else "./*"} $out
      chmod -R 755 $out
      cd ${outPrefix}

      rm -rf ./{Music,Sounds,Maps}
      ln -s ${unpackGog}/{Music,Sounds,Maps} .

      cp -n ${unpackGog}/Textures/* ./Textures || true
      cp -n ${unpackGog}/System/*.{u,int} ./System || true
    ''
    + lib.optionalString (stdenv.isLinux) ''
      ln -s "$out/${systemDir}/ut-bin" "$out/bin/ut1999"
      ln -s "$out/${systemDir}/ucc-bin" "$out/bin/ut1999-ucc"

      convert "${unpackGog}/gfw_high.ico" "ut1999.png"
      install -D ut1999-5.png "$out/share/icons/hicolor/256x256/apps/ut1999.png"

      # Remove bundled libraries to use native versions instead
      rm $out/${systemDir}/libmpg123.so* \
        $out/${systemDir}/libopenal.so* \
        $out/${systemDir}/libSDL2* \
        $out/${systemDir}/libxmp.so*
    ''
    + ''
      runHook postInstall
    '';

  # .so files in the SystemARM64 directory are not loaded properly on aarch64-linux
  appendRunpaths = lib.optionals (stdenv.hostPlatform.system == "aarch64-linux") [
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
    description = "Unreal Tournament GOTY (1999) with the OldUnreal patch.";
    license = licenses.unfree;
    platforms = attrNames srcs;
    maintainers = with maintainers; [ eliandoran ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    mainProgram = "ut1999";
  };
}
