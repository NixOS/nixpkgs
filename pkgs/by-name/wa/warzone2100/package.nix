{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  cmake,
  ninja,
  p7zip,
  pkg-config,
  asciidoctor,
  gettext,

  sdl3,
  libtheora,
  libvorbis,
  libopus,
  openal,
  openal-soft,
  physfs,
  miniupnpc,
  libsodium,
  curl,
  libpng,
  freetype,
  harfbuzz,
  sqlite,
  which,
  vulkan-headers,
  vulkan-loader,
  shaderc,
  protobuf,
  libzip,

  makeBinaryWrapper,

  makeWrapper,

  testers,
  warzone2100,
  nixosTests,

  gitUpdater,

  withVideos ? true,
}:

let
  sequences = fetchurl {
    url = "mirror://sourceforge/warzone2100/warzone2100/Videos/high-quality-en/sequences.wz";
    hash = "sha256-kP9VLKSnDiU34CfiLFCY6k7RvBG7f8lBOMbJQac9Kfo=";
  };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "warzone2100";
  version = "4.7.0";

  src = fetchFromGitHub {
    owner = "Warzone2100";
    repo = "warzone2100";
    rev = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-GZiBs+aUeRCFixSWJscG47W7Ypgz3mLPHtkNKr4nnvs=";
  };

  buildInputs = [
    sdl3
    libtheora
    libvorbis
    libopus
    openal
    openal-soft
    physfs
    miniupnpc
    libsodium
    curl
    libpng
    freetype
    harfbuzz
    sqlite
    protobuf
    libzip
    vulkan-headers
    vulkan-loader
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
    ninja
    p7zip
    asciidoctor
    gettext
    makeBinaryWrapper
    shaderc
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    makeWrapper
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-fobjc-arc";

  postPatch =
    let
      cacheContent = lib.generators.toKeyValue { } {
        VCS_TYPE = "git";
        VCS_BASENAME = "warzone2100";
        VCS_TAG = finalAttrs.version;
        VCS_TAG_TAG_COUNT = 1;
        VCS_FULL_HASH = "0000000000000000000000000000000000000000";
        VCS_SHORT_HASH = "0000000";
        VCS_WC_MODIFIED = 0;
        VCS_REPO_IS_SHALLOW = 0;
        VCS_COMMIT_COUNT = 0;
        VCS_MOST_RECENT_TAGGED_VERSION = finalAttrs.version;
        VCS_MOST_RECENT_TAGGED_VERSION_TAG_COUNT = 0;
        VCS_COMMIT_COUNT_SINCE_MOST_RECENT_TAGGED_VERSION = 0;
        VCS_COMMIT_COUNT_ON_MASTER_UNTIL_BRANCH = 0;
        VCS_BRANCH_COMMIT_COUNT = 0;
        VCS_MOST_RECENT_COMMIT_DATE = "2024-01-01";
        VCS_MOST_RECENT_COMMIT_YEAR = "2024";
      };
    in
    ''
      printf '%s' '${cacheContent}' > build_tools/autorevision.cache

      substituteInPlace CMakeLists.txt \
        --replace-fail "CONFIGURE_WZ_COMPILER_WARNINGS()" ""

      DOLLAR='$'
      substituteInPlace 3rdparty/basis_universal_host_build/CMakeLists.txt \
        --replace-fail "''${DOLLAR}{CMAKE_COMMAND} chdir" "''${DOLLAR}{CMAKE_COMMAND} -E chdir"
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      substituteInPlace src/CMakeLists.txt \
        --replace-fail 'if(CMAKE_SYSTEM_NAME MATCHES "Darwin")' 'if(FALSE)'
    '';

  cmakeFlags = [
    "-DWZ_DISTRIBUTOR=NixOS"
    # The cmake builder automatically sets CMAKE_INSTALL_BINDIR to an absolute
    # path, but this results in an error:
    #
    # > An absolute CMAKE_INSTALL_BINDIR path cannot be used if the following
    # > are not also absolute paths: WZ_DATADIR
    #
    # WZ_DATADIR is based on CMAKE_INSTALL_DATAROOTDIR, so we set that.
    #
    # Alternatively, we could have set CMAKE_INSTALL_BINDIR to "bin".
    "-DCMAKE_INSTALL_DATAROOTDIR=${placeholder "out"}/share"
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin ''
    -DWZ_ENABLE_BACKEND_VULKAN=OFF
  '';

  postInstall =
    (lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
      wrapProgram $out/bin/warzone2100 \
        --prefix PATH : ${lib.makeBinPath [ which ]}
    '')
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      appBundle="$out/Applications/Warzone 2100.app"
      mkdir -p "$appBundle/Contents/MacOS"
      mkdir -p "$appBundle/Contents/Resources"

      mv "$out/bin/warzone2100" "$appBundle/Contents/MacOS/Warzone 2100"

      ln -s "$out/share/warzone2100" "$appBundle/Contents/Resources/data"
      ln -s "$out/share/locale" "$appBundle/Contents/Resources/locale"
      ln -s "$out/share/doc/warzone2100" "$appBundle/Contents/Resources/docs"
      cp "$NIX_BUILD_TOP/$sourceRoot/platforms/macos/Resources/Warzone.icns" \
        "$appBundle/Contents/Resources/Warzone.icns"

      plist="$appBundle/Contents/Info.plist"
      cp "$NIX_BUILD_TOP/$sourceRoot/platforms/macos/Resources/Warzone-Info.plist.in" "$plist"
      substituteInPlace "$plist" \
        --replace-fail '$(EXECUTABLE_NAME)' 'Warzone 2100' \
        --replace-fail '$(PRODUCT_BUNDLE_IDENTIFIER)' 'net.wz2100.Warzone2100' \
        --replace-fail '$(MACOSX_DEPLOYMENT_TARGET)' '14' \
        --replace-fail '@WZINFO_CFBundleGetInfoString@' 'Warzone 2100 ${finalAttrs.version}' \
        --replace-fail '@MAC_VERSION_NUMBER@' '${finalAttrs.version}' \
        --replace-fail '@MAC_BUILD_NUMBER@' '${finalAttrs.version}' \
        --replace-fail '@WZINFO_NSHumanReadableCopyright@' 'Copyright The Warzone 2100 Project' \
        --replace-fail '@VCS_FULL_HASH@' '0000000000000000000000000000000000000000' \
        --replace-fail '@VCS_SHORT_HASH@' '0000000'

      makeBinaryWrapper \
        "$appBundle/Contents/MacOS/Warzone 2100" \
        "$out/bin/warzone2100"
    ''
    + lib.optionalString withVideos ''
      ln -sn ${sequences} $out/share/warzone2100/sequences.wz
    '';

  passthru.tests = {
    version = testers.testVersion {
      package = warzone2100;
      # The command always exits with code 1
      command = "(warzone2100 --version || [ $? -eq 1 ])";
    };
    nixosTest = nixosTests.warzone2100;
  };

  passthru.updateScript = gitUpdater {
    url = "https://github.com/Warzone2100/warzone2100";
  };

  meta = {
    changelog = "https://github.com/Warzone2100/warzone2100/blob/${finalAttrs.version}/ChangeLog";
    description = "Free RTS game, originally developed by Pumpkin Studios";
    mainProgram = "warzone2100";
    longDescription = ''
        Warzone 2100 is an open source real-time strategy and real-time tactics
      hybrid computer game, originally developed by Pumpkin Studios and
      published by Eidos Interactive.
        In Warzone 2100, you command the forces of The Project in a battle to
      rebuild the world after mankind has almost been destroyed by nuclear
      missiles. The game offers campaign, multi-player, and single-player
      skirmish modes. An extensive tech tree with over 400 different
      technologies, combined with the unit design system, allows for a wide
      variety of possible units and tactics.
    '';
    homepage = "https://wz2100.net";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      fgaz
      philocalyst
    ];
    platforms = lib.platforms.all;
  };
})
