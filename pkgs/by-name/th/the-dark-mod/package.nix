{
  lib,
  stdenv,
  fetchsvn,

  cmake,
  ninja,
  xorg,
  iconConvTools,
  makeDesktopItem,
  copyDesktopItems,
  writableDirWrapper,

  addDriverRunpath,
  libGL,
  alsa-lib,
  makeBinaryWrapper,
  the-dark-mod-assets,
}:
let
  libPath = lib.makeLibraryPath [
    # GLFW
    addDriverRunpath.driverLink
    libGL
    xorg.libX11
    xorg.libXcursor
    xorg.libXext
    xorg.libXrandr
    xorg.libXxf86vm

    # OpenAL
    alsa-lib
  ];

  gameDir = "\${XDG_DATA_HOME:-$HOME/.local/share}/darkmod";

  description = "Dark and moody stealth game inspired by the Thief series by Looking Glass Studios";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "the-dark-mod";
  version = "2.12";

  # We use the SVN repo as it contains built static binaries that are not
  # present in the Git mirror. Currently Nixpkgs only supports a limited set
  # of packages that can be statically linked (notably excluding ffmpeg, pulseaudio
  # and pipewire), so we couldn't build everything from scratch even if we want to :(
  src = fetchsvn {
    url = "https://svn.thedarkmod.com/publicsvn/darkmod_src/tags/${finalAttrs.version}";
    rev = "10652";
    hash = "sha256-jPQWoLlsUQqpBB1BECR9m/p+HwD0jJlpqwUaIqygwP0=";
  };

  outputs = [
    "out"
    "debug"
  ];

  nativeBuildInputs = [
    cmake
    ninja
    makeBinaryWrapper
    iconConvTools
    copyDesktopItems
    writableDirWrapper
  ];

  buildInputs = [
    xorg.xorgproto
    xorg.libX11
    xorg.libXxf86vm
    xorg.libXext
  ];

  cmakeFlags = [
    (lib.cmakeFeature "GAME_DIR" "${placeholder "out"}/bin")
  ];

  # O_O it installs stuff in buildPhase...
  preBuild = ''
    mkdir -p $out/bin
  '';

  dontUseNinjaInstall = true;

  desktopItems = [
    (makeDesktopItem {
      name = "the-dark-mod";
      desktopName = "The Dark Mod";
      comment = description;
      icon = "the-dark-mod";
      exec = "the-dark-mod";
      categories = [
        "Game"
        "ActionGame"
        "AdventureGame"
        "RolePlaying"
      ];
      keywords = [
        "Stealth"
        "Steampunk"
        "Thief"
      ];
      prefersNonDefaultGPU = true;
    })
  ];

  postInstall = ''
    icoFileToHiColorTheme ${the-dark-mod-assets}/darkmod.ico the-dark-mod $out
  '';

  postFixup = ''
    moveToOutput bin/thedarkmod.x64.debug $debug
    mv $out/bin/thedarkmod.x64 $out/bin/the-dark-mod

    wrapProgramInWritableDir $out/bin/the-dark-mod '${gameDir}' \
      --prefix LD_LIBRARY_PATH : ${libPath} \
      --set ALSOFT_CONF ${the-dark-mod-assets}/alsoft.ini \
      --add-flags '+set fs_basepath "${the-dark-mod-assets}"' \
      --add-flags '+set fs_savepath "${gameDir}"' \
      --add-flags '+set fs_modSavePath "${gameDir}/fms"'
  '';

  passthru.installer = stdenv.mkDerivation {
    pname = "the-dark-mod-installer";
    inherit (finalAttrs) version src;
    sourceRoot = "${finalAttrs.src.name}/tdm_installer";

    nativeBuildInputs = [
      cmake
      ninja
    ];
    buildInputs = [
      xorg.libX11
      xorg.libXext
    ];

    installPhase = ''
      runHook preInstall
      install -Dm755 tdm_installer.linux64 -t $out/bin
      runHook postInstall
    '';

    meta.mainProgram = "tdm_installer.linux64";
  };

  meta = {
    inherit description;
    homepage = "https://www.thedarkmod.com/";
    changelog = "https://wiki.thedarkmod.com/index.php?title=What%27s_new_in_TDM_${finalAttrs.version}";
    license = with lib.licenses; [
      gpl3Plus # Portions based on Doom 3
      bsd3 # Original code
    ];
    # Other Linux platforms may work (including i686-linux) but are not officially supported
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ pluiedev ];
    mainProgram = "the-dark-mod";
  };
})
