{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  nix-update-script,
  cmake,
  ninja,
  pkg-config,
  libx11,
  libxrandr,
  libxinerama,
  libxext,
  libxcursor,
  freetype,
  fontconfig,
  alsa-lib,

  buildStandalone ? true,
  buildVST3 ? true,
}:

let
  pluginFormats = [
    (lib.optionalString buildStandalone "Standalone")
    (lib.optionalString buildVST3 "VST3")
  ];
in

stdenv.mkDerivation (finalAttrs: {
  name = "wildergarden-maim";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "ArdenButterfield";
    repo = "Maim";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-Ot2RAcqF4NpHlkSdekEs6w3uspMD09/vV8nGjfAtsb0=";
  };

  patches = [
    # Hide JUCE splash screen
    # TODO: remove on update, merged upstream
    (fetchpatch {
      url = "https://github.com/ArdenButterfield/Maim/pull/66.diff";
      hash = "sha256-oVpsEtfLlqio1HJzGplTGZqzdvn2P1u1ypAd0iHKLRw=";
    })
  ];

  preConfigure = ''
    pushd lib/lame
      ./configure --disable-frontend --enable-expopt=full --disable-shared --enable-static
      make -j$NIX_BUILD_CORES
    popd
  '';

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "set(FORMATS Standalone AU VST3 AUv3)" "set(FORMATS ${lib.concatStringsSep " " pluginFormats})"

    substituteInPlace CMakeLists.txt \
      --replace-fail "COPY_PLUGIN_AFTER_BUILD TRUE" "COPY_PLUGIN_AFTER_BUILD FALSE"

    substituteInPlace CMakeLists.txt \
      --replace-fail "include(Tests)" "# No tests" \
      --replace-fail "include(Benchmarks)" "# No benchmarks"
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  buildInputs = [
    fontconfig
    freetype
  ]
  ++ lib.optionals stdenv.isLinux [
    libx11
    libxcursor
    libxext
    libxinerama
    libxrandr
    alsa-lib
  ];

  # Needed for standalone
  NIX_LDFLAGS = lib.optional stdenv.hostPlatform.isLinux "-lX11";

  cmakeFlags = [
    (lib.cmakeFeature "LAME_LIB" "lib/lame/libmp3lame/.libs/libmp3lame.a")
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "-DCMAKE_OSX_ARCHITECTURES=${stdenv.hostPlatform.darwinArch}"
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isLinux (toString [
    # juce, compiled in this build as part of a Git submodule, uses `-flto` as
    # a Link Time Optimization flag, and instructs the plugin compiled here to
    # use this flag to. This breaks the build for us. Using _fat_ LTO allows
    # successful linking while still providing LTO benefits. If our build of
    # `juce` was used as a dependency, we could have patched that `-flto` line
    # in our juce's source, but that is not possible because it is used as a
    # Git Submodule.
    "-ffat-lto-objects"
  ]);

  installPhase = ''
    runHook preInstall

    pushd Maim_artefacts/Release
      ${lib.optionalString buildStandalone ''
        mkdir -p $out/bin
        install -Dm755 -t $out/bin Standalone/Maim
      ''}

      ${lib.optionalString buildVST3 ''
        mkdir -p $out/lib/vst3
        cp -r VST3/Maim.vst3 $out/lib/vst3/
      ''}
    popd

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Audio plugin for custom MP3 distortion and digital glitches";
    homepage = "https://github.com/ArdenButterfield/Maim";
    platforms = lib.platforms.all;
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.mrtnvgr ];
  }
  // lib.optionalAttrs buildStandalone {
    mainProgram = "Maim";
  };
})
