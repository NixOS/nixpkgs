{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
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

  testers,
  warzone2100,
  nixosTests,

  gitUpdater,

  withVideos ? true,
}:

let
  pname = "warzone2100";

  sequences = fetchurl {
    url = "mirror://sourceforge/warzone2100/warzone2100/Videos/high-quality-en/sequences.wz";
    hash = "sha256-kP9VLKSnDiU34CfiLFCY6k7RvBG7f8lBOMbJQac9Kfo=";
  };
in

stdenv.mkDerivation (finalAttrs: {
  inherit pname;
  version = "4.7.0";

  src = fetchurl {
    url = "mirror://sourceforge/project/warzone2100/releases/${finalAttrs.version}/warzone2100_src.tar.xz";
    hash = "sha256-le5NW4hoDqGxzyMLZ+qEAo4IokWLhGBayff7nrl8Tjc=";
  };

  # Build and runtime compatibility with vulkan-headers 1.4.350+, backported
  # from upstream master. Can be dropped on the next version bump.
  # https://github.com/Warzone2100/warzone2100/pull/4918
  # https://github.com/Warzone2100/warzone2100/pull/5026
  patches = [
    (fetchpatch {
      name = "vulkan-headers-1.4.350-drop-deprecated-colorspace-alias.patch";
      url = "https://github.com/Warzone2100/warzone2100/commit/ac504348136e22f434fc3d7c81ec0a0605f206a8.patch";
      hash = "sha256-Rk6Hq5d78ZZfr2/Ar1LFrG40rjuVBdvVLs5InVBPn58=";
    })
    (fetchpatch {
      name = "vulkan-headers-1.4.357-dispatch-loader-init.patch";
      url = "https://github.com/Warzone2100/warzone2100/commit/dab3aaf985f0e4190fec6990268cd39f44dc21ec.patch";
      hash = "sha256-CfK05EQKR5RcRvc7tmiF5VU/9lwzbVmiU58lXwYivQQ=";
    })
  ];

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
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
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
    shaderc
  ];

  postPatch = ''
    substituteInPlace lib/exceptionhandler/dumpinfo.cpp \
                      --replace '"which "' '"${which}/bin/which "'
    substituteInPlace lib/exceptionhandler/exceptionhandler.cpp \
                      --replace "which %s" "${which}/bin/which %s"
    substituteInPlace CMakeLists.txt \
      --replace-fail "CONFIGURE_WZ_COMPILER_WARNINGS()" ""
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
  ++ lib.optional stdenv.hostPlatform.isDarwin "-P../configure_mac.cmake";

  postInstall = lib.optionalString withVideos ''
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
    ];
    platforms = lib.platforms.all;
    # configure_mac.cmake tries to download stuff
    # https://github.com/Warzone2100/warzone2100/blob/master/macosx/README.md
    broken = stdenv.hostPlatform.isDarwin;
  };
})
