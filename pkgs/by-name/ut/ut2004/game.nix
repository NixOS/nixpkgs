{
  autoPatchelfHook,
  copyDesktopItems,
  fetchurl,
  imagemagick,
  lib,
  libGL,
  libarchive,
  makeDesktopItem,
  openal,
  sdl3,
  stdenv,
  ut2004Packages,
}:

let
  gameData = ut2004Packages.data;
  patch-version = "3374-preview-17";
  patch =
    rec {
      aarch64-linux = x86_64-linux;
      x86_64-linux = fetchurl {
        url = "https://github.com/OldUnreal/UT2004Patches/releases/download/${patch-version}/OldUnreal-UT2004Patch3374-Linux-6369f34c.tar.bz2";
        hash = "sha256-/PGV58gVe/R3lzYLheXfMWS4Y4KXp/oIzfIAorGxQzo=";
      };
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");
  systemDir =
    {
      aarch64-linux = "SystemARM64";
      x86_64-linux = "System";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ut2004";
  version = patch-version;

  __structuredAttrs = true;
  strictDeps = true;

  src = patch;

  buildInputs = [
    gameData
  ]
  ++ [
    libGL
    openal
    sdl3
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    imagemagick
    libarchive
  ];

  unpackPhase = ''
    # Install files to their (relative) final location.
    # https://github.com/OldUnreal/FullGameInstallers/blob/748525188b80f47138f19af6c8c6899230cb214e/Linux/install-ut2004.sh#L2087-L2155.
    mkdir -p ut2004/System

    for folder in Animations Benchmark ForceFeedback Help KarmaData Maps Music StaticMeshes Textures Web; do
      cp --no-preserve=mode -vrs ${gameData}/"All_$folder" ut2004/"$folder"
    done

    cp --no-preserve=mode -vrs ${gameData}/English_Manual ut2004/Manual
    cp --no-preserve=mode -vrs ${gameData}/English_Sounds_Speech_System_Help/Sounds ut2004
    cp --no-preserve=mode -vrs ${gameData}/English_Sounds_Speech_System_Help/Speech ut2004

    cp --no-preserve=mode -vrs ${gameData}/All_UT2004.EXE/* ut2004/System
    cp --no-preserve=mode -vrs ${gameData}/English_Sounds_Speech_System_Help/Help/* ut2004/Help
    cp --no-preserve=mode -vrs ${gameData}/English_Sounds_Speech_System_Help/System/* ut2004/System
    cp --no-preserve=mode -vrs ${gameData}/US_License.int ut2004/System

    # Patch.
    bsdtar --unlink-first -xf "${patch}" -C ut2004

    # Remove files superseded by the patch.
    # https://github.com/OldUnreal/FullGameInstallers/blob/748525188b80f47138f19af6c8c6899230cb214e/Linux/install-ut2004.sh#L2169-L2194
    rm -v -- ut2004/System/{StreamLineFX,XVoting}.u

    # Remove windows files.
    # https://github.com/OldUnreal/FullGameInstallers/blob/748525188b80f47138f19af6c8c6899230cb214e/Linux/install-ut2004.sh#L2087-L2155.
    rm -v -- ut2004/System/*.bat
    rm -v -- ut2004/System/*.dll
    rm -v -- ut2004/System/*.exe

    # Remove unused architectures.
    if [ "${systemDir}" != System ]; then
        rm -v -- ut2004/System/*.so
        rm -v -- ut2004/System/{UT2004,ut2004-bin,ut2004-bin-amd64}
        rm -v -- ut2004/System/{UCC,ucc-bin,ucc-bin-amd64}
    fi
    for dir in SystemARM64 SystemPPC64LE; do
      if [ "${systemDir}" != "$dir" ]; then
        rm -rfv -- ut2004/"$dir"
      fi
    done

    # Use system dependencies.
    rm -v -- ut2004/${systemDir}/libopenal.so.1
    rm -v -- ut2004/${systemDir}/libopenal.so.1.*
    rm -v -- ut2004/${systemDir}/libSDL3.so.0
    rm -v -- ut2004/${systemDir}/libSDL3.so.0.*

    # Make icons.
    # identify Unreal.ico
    # Unreal.ico[0] ICO 48x48 48x48+0+0 4-bit sRGB 0.000u 0:00.000
    # Unreal.ico[1] ICO 32x32 32x32+0+0 4-bit sRGB 0.000u 0:00.000
    # Unreal.ico[2] ICO 16x16 16x16+0+0 4-bit sRGB 0.000u 0:00.000
    # Unreal.ico[3] ICO 48x48 48x48+0+0 8-bit sRGB 0.000u 0:00.000
    # Unreal.ico[4] ICO 32x32 32x32+0+0 8-bit sRGB 0.000u 0:00.000
    # Unreal.ico[5] ICO 16x16 16x16+0+0 8-bit sRGB 0.000u 0:00.000
    # Unreal.ico[6] ICO 48x48 48x48+0+0 8-bit sRGB 0.000u 0:00.000
    # Unreal.ico[7] ICO 32x32 32x32+0+0 8-bit sRGB 24070B 0.000u 0:00.000
    icon_src=ut2004/Help/Unreal.ico
    mkdir -p icons/hicolor/{16x16,32x32,48x48}
    magick -background none "$icon_src[5]" icons/hicolor/16x16/ut2004.png
    magick -background none "$icon_src[7]" icons/hicolor/32x32/ut2004.png
    magick -background none "$icon_src[6]" icons/hicolor/48x48/ut2004.png
  '';

  installPhase = ''
    # Install game data.
    mkdir -p "$out"/opt
    mv ut2004 "$out"/opt

    # Install icons.
    mkdir -p "$out"/share
    mv icons "$out"/share

    # Install binaries.
    mkdir -p "$out"/bin
    ln -s "$out"/opt/ut2004/${systemDir}/ut2004-bin "$out"/bin/ut2004
    ln -s "$out"/opt/ut2004/${systemDir}/ucc-bin "$out"/bin/ut2004-ucc

    runHook postInstall
  '';

  appendRunpaths = [
    "${placeholder "out"}/opt/ut2004/System"
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "ut2004";
      desktopName = "Unreal Tournament 2004";
      comment = "Unreal Tournament 2004 with OldUnreal patch ${patch-version}";
      exec = "ut2004";
      icon = "ut2004";
      categories = [ "Game" ];
    })
  ];

  meta = {
    description = ''
      Unreal Tournament 2004 with OldUnreal patch ${patch-version}.
      Pin ut2004Packages.image to avoid downloading the disc image when build tools are updated (for example libarchive) at the cost of extra disk space.
      To save disk space, pin ut2004Packages.data instead of ut2004Packages.image to avoid downloading the disc image when the patch is updated.
    '';
    homepage = "https://oldunreal.com/downloads/ut2004/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ corps-fini ];
    mainProgram = "ut2004";
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
