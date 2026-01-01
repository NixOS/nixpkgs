{
<<<<<<< HEAD
=======
  lib,
  stdenv,
  fetchFromGitHub,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  SDL2,
  SDL2_image,
  SDL2_mixer,
  SDL2_ttf,
  boost,
  cmake,
<<<<<<< HEAD
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
  version = "1.7.0";
=======
  ffmpeg,
  fuzzylite,
  innoextract,
  luajit,
  minizip,
  ninja,
  pkg-config,
  python3,
  onetbb,
  unshield,
  xz,
  zlib,
  testers,
  vcmi,
  libsForQt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vcmi";
  version = "1.6.8";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "vcmi";
    repo = "vcmi";
    tag = finalAttrs.version;
    fetchSubmodules = true;
<<<<<<< HEAD
    hash = "sha256-wwPlsXJd34OYfLdCkCl6PdboEo+9/ZPQWgmSxn88W+k=";
=======
    hash = "sha256-k6tkylNXEzU+zzYoFWtx+AkoHQzAwbBxPB2DVevsryw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    python3
<<<<<<< HEAD
    qt6.wrapQtAppsHook
=======
    libsForQt5.wrapQtAppsHook
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  buildInputs = [
    SDL2
    SDL2_image
    SDL2_mixer
    SDL2_ttf
    boost
    ffmpeg
    fuzzylite
<<<<<<< HEAD
    libsquish
    luajit
    minizip
    onetbb
    onnxruntime
    qt6.qtbase
    qt6.qttools
=======
    luajit
    minizip
    libsForQt5.qtbase
    libsForQt5.qttools
    onetbb
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    xz
    zlib
  ];

  cmakeFlags = [
<<<<<<< HEAD
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
=======
    "-DENABLE_LUA:BOOL=ON"
    "-DENABLE_ERM:BOOL=ON"
    "-DENABLE_GOLDMASTER:BOOL=ON"
    "-DENABLE_PCH:BOOL=OFF"
    "-DENABLE_TEST:BOOL=OFF" # Tests require HOMM3 data files.
    "-DFORCE_BUNDLED_MINIZIP:BOOL=OFF"
    "-DFORCE_BUNDLED_FL:BOOL=OFF"
    "-DCMAKE_INSTALL_RPATH:STRING=$out/lib/vcmi"
    "-DCMAKE_INSTALL_BINDIR:STRING=bin"
    "-DCMAKE_INSTALL_LIBDIR:STRING=lib"
    "-DCMAKE_INSTALL_DATAROOTDIR:STRING=share"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
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
=======
  passthru.tests.version = testers.testVersion {
    package = vcmi;
    command = ''
      XDG_DATA_HOME="$TMPDIR" XDG_CACHE_HOME="$TMPDIR" XDG_CONFIG_HOME="$TMPDIR" \
        vcmiclient --version
    '';
  };

  meta = {
    description = "Open-source engine for Heroes of Might and Magic III";
    homepage = "https://vcmi.eu";
    changelog = "https://github.com/vcmi/vcmi/blob/${finalAttrs.src.rev}/ChangeLog.md";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    license = with lib.licenses; [
      gpl2Plus
      cc-by-sa-40
    ];
<<<<<<< HEAD
    maintainers = [ lib.maintainers.azahi ];
=======
    maintainers = with lib.maintainers; [ azahi ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    platforms = lib.platforms.linux;
    mainProgram = "vcmilauncher";
  };
})
