{
  stdenv,
  lib,
  fetchFromGitLab,
  cmake,
  pkg-config,
  makeWrapper,
  callPackage,
  soundfont-fluid,
  SDL_compat,
  libGL,
  libopus,
  glew,
  bzip2,
  zlib,
  libjpeg,
  fluidsynth,
  fmodex,
  openssl,
  gtk2,
  python3,
  game-music-emu,
  copyDesktopItems,
  makeDesktopItem,
  imagemagick,
  serverOnly ? false,
}:

let
  suffix = lib.optionalString serverOnly "-server";
  fmod = fmodex; # fmodex is on nixpkgs now
  sqlite = callPackage ./sqlite.nix { };
  clientLibPath = lib.makeLibraryPath [ fluidsynth ];

in
stdenv.mkDerivation (finalAttrs: {
  pname = "zandronum${suffix}";
  version = "3.2.1";

  src = fetchFromGitLab {
    domain = "foss.heptapod.net";
    owner = "zandronum";
    repo = "zandronum-stable";
    tag = "ZA_${finalAttrs.version}";
    hash = "sha256-A5sfZMiCypBxAUOsoB8yuinZf7b9D7+HH9rpVs3esgA=";
  };

  # zandronum tries to download sqlite now when running cmake, don't let it
  patches = [
    ./zan_configure_impurity.patch
  ];

  # I have no idea why would SDL and libjpeg be needed for the server part!
  # But they are.
  buildInputs = [
    openssl
    bzip2
    zlib
    SDL_compat
    libjpeg
    sqlite
    game-music-emu
  ]
  ++ lib.optionals (!serverOnly) [
    libGL
    glew
    fmod
    fluidsynth
    libopus
    gtk2
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
    python3
    copyDesktopItems
    imagemagick
  ];

  preConfigure = ''
    ln -s ${sqlite}/* sqlite/
    sed -i -e 's| restrict| _restrict|g' dumb/include/dumb.h \
                                       dumb/src/it/*.c
  ''
  + lib.optionalString (!serverOnly) ''
    sed -i \
      -e "s@/usr/share/sounds/sf2/@${soundfont-fluid}/share/soundfonts/@g" \
      -e "s@FluidR3_GM.sf2@FluidR3_GM2-2.sf2@g" \
      src/sound/music_fluidsynth_mididevice.cpp
  '';

  cmakeFlags = [
    "-DFORCE_INTERNAL_GME=OFF"
  ]
  ++ (if serverOnly then [ "-DSERVERONLY=ON" ] else [ "-DFMOD_LIBRARY=${fmod}/lib/libfmodex.so" ]);

  hardeningDisable = [ "format" ];

  desktopItems = [
    (makeDesktopItem {
      name = "zandronum";
      desktopName = "Zandronum";
      exec = "zandronum";
      icon = "zandronum";
      mimeTypes = [ "application/x-doom-wad" ];
      categories = [ "Game" ];
      comment = finalAttrs.meta.description;
    })
  ];

  # Won't work well without C or en_US. Setting LANG might not be enough if the user is making use of LC_* so wrap with LC_ALL instead
  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/lib/zandronum
    cp zandronum${suffix} \
       *.pk3 \
       ${lib.optionalString (!serverOnly) "liboutput_sdl.so"} \
       $out/lib/zandronum
    makeWrapper $out/lib/zandronum/zandronum${suffix} $out/bin/zandronum${suffix}
    wrapProgram $out/bin/zandronum${suffix} \
      --set LC_ALL="C"

    # Upstream only provides an icon file for Windows.
    # This converts the .ico file to PNGs, which are used by the desktop file.
    for size in 16 24 32 48 64 128 256; do
      mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
      magick $src/src/win32/zandronum.ico -background none -resize "$size"x"$size" -flatten \
        $out/share/icons/hicolor/"$size"x"$size"/apps/zandronum.png
    done;

    runHook postInstall
  '';

  postFixup = lib.optionalString (!serverOnly) ''
    patchelf --set-rpath $(patchelf --print-rpath $out/lib/zandronum/zandronum):$out/lib/zandronum:${clientLibPath} \
      $out/lib/zandronum/zandronum
  '';

  passthru = {
    inherit fmod sqlite;
  };

  meta = {
    homepage = "https://zandronum.com/";
    description = "Multiplayer oriented port, based off Skulltag, for Doom and Doom II by id Software";
    mainProgram = "zandronum-server";
    maintainers = with lib.maintainers; [ lassulus ];
    license = lib.licenses.sleepycat;
    platforms = lib.platforms.linux;
  };
})
