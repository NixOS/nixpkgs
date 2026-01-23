{
  SDL2,
  SDL2_image,
  SDL2_mixer,
  SDL2_ttf,
  boost,
  cmake,
  fetchFromGitHub,
  ffmpeg,
  fuzzylite,
  innoextract,
  lib,
  libsquish,
  luajit,
  minizip,
  ninja,
  onetbb,
  onnxruntime,
  pkg-config,
  python3,
  qt6,
  stdenv,
  unshield,
  versionCheckHook,
  xz,
  zlib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "vcmi";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "vcmi";
    repo = "vcmi";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-3XZQyq6urCTI/A6tCSHgzPgOvzH8ckXvDRamWvVgeVY=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    python3
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    SDL2
    SDL2_image
    SDL2_mixer
    SDL2_ttf
    boost
    ffmpeg
    fuzzylite
    libsquish
    luajit
    minizip
    onetbb
    onnxruntime
    qt6.qtbase
    qt6.qttools
    xz
    zlib
  ];

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_CLIENT" true)
    (lib.cmakeBool "ENABLE_LUA" true)
    (lib.cmakeBool "ENABLE_ERM" true)
    (lib.cmakeBool "ENABLE_GOLDMASTER" true)
    (lib.cmakeBool "ENABLE_TEST" false) # Requires nonfree data files.
    (lib.cmakeBool "ENABLE_PCH" false)
    (lib.cmakeFeature "CMAKE_INSTALL_RPATH" "$out/lib/vcmi")
    (lib.cmakeFeature "CMAKE_INSTALL_BINDIR" "bin")
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
    (lib.cmakeFeature "CMAKE_INSTALL_DATAROOTDIR" "share")
  ];

  postFixup = ''
    wrapProgram $out/bin/vcmibuilder \
      --prefix PATH : "${
        lib.makeBinPath [
          innoextract
          ffmpeg
          unshield
        ]
      }"
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/vcmiclient";
  versionCheckProgramArg = "--version";
  versionCheckKeepEnvironment = [
    "XDG_CACHE_HOME"
    "XDG_CONFIG_HOME"
    "XDG_DATA_HOME"
  ];
  preVersionCheck = ''
    export \
      XDG_CACHE_HOME="$TMPDIR" \
      XDG_CONFIG_HOME="$TMPDIR" \
      XDG_DATA_HOME="$TMPDIR"
  '';

  meta = {
    description = "Open-source engine for Heroes of Might and Magic III";
    longDescription = ''
      VCMI is an open-source engine for Heroes of Might and Magic III, offering
      new and extended possibilities. To use VCMI, you need to own the original
      data files.
    '';
    homepage = "https://vcmi.eu";
    changelog = "https://vcmi.eu/ChangeLog";
    license = with lib.licenses; [
      gpl2Plus
      cc-by-sa-40
    ];
    maintainers = [ lib.maintainers.azahi ];
    platforms = lib.platforms.linux;
    mainProgram = "vcmilauncher";
  };
})
