{
  lib,
  clangStdenv,
  fetchFromGitHub,

  # nativeBuildInputs
  cmake,
  darwin,
  ninja,
  pkg-config,
  writableTmpDirAsHomeHook,

  # buildInputs
  alsa-lib,
  curl,
  expat,
  fontconfig,
  freetype,
  libGL,
  libxcursor,
  libxext,
  libxinerama,
  libxrandr,
  libepoxy,
  libjack2,
  libxkbcommon,
  lv2,
}:

clangStdenv.mkDerivation (finalAttrs: {
  pname = "zlcompressor";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "ZL-Audio";
    repo = "ZLCompressor";
    tag = finalAttrs.version;
    hash = "sha256-u+2cfCNjMUXo+7/qBUU4BdDQcUyeQfd9kvARi3AAK48=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    writableTmpDirAsHomeHook
  ]
  ++ lib.optionals clangStdenv.hostPlatform.isDarwin [ darwin.sigtool ];

  buildInputs = [
    curl
    expat
    fontconfig
    freetype
    lv2
  ]
  ++ lib.optionals clangStdenv.hostPlatform.isLinux [
    alsa-lib
    libGL
    libxcursor
    libxext
    libxinerama
    libxrandr
    libepoxy
    libjack2
    libxkbcommon
  ];

  # JUCE dlopen's these at runtime, crashes without them
  env = lib.optionalAttrs clangStdenv.hostPlatform.isLinux {
    NIX_LDFLAGS = toString [
      "-lX11"
      "-lXext"
      "-lXcursor"
      "-lXinerama"
      "-lXrandr"
    ];
    NIX_CFLAGS_COMPILE = toString [
      # juce, compiled in this build as part of a Git submodule, uses `-flto` as
      # a Link Time Optimization flag, and instructs the plugin compiled here to
      # use this flag to. This breaks the build for us. Using _fat_ LTO allows
      # successful linking while still providing LTO benefits. If our build of
      # `juce` was used as a dependency, we could have patched that `-flto` line
      # in our juce's source, but that is not possible because it is used as a
      # Git Submodule.
      "-ffat-lto-objects"
    ];
  };

  cmakeFlags = [
    # see: https://github.com/ZL-Audio/ZlEqualizer#clone-and-build
    (lib.cmakeFeature "KFR_ARCHS" (
      if clangStdenv.hostPlatform.isAarch64 then "neon64" else "sse2;avx;avx2"
    ))
    (lib.cmakeBool "ZL_JUCE_COPY_PLUGIN" false)
    # set the version for in the settings screen.
    (lib.cmakeFeature "FOOBAR_VERSION" "${finalAttrs.version}")
  ];

  installPhase = ''
    runHook preInstall
  ''
  + lib.optionalString clangStdenv.hostPlatform.isLinux ''
    mkdir -p $out/lib/{lv2,vst3}
    mkdir -p $out/bin/
    cp -r "ZLCompressor_artefacts/Release/LV2/ZL Compressor.lv2" $out/lib/lv2/
    cp -r "ZLCompressor_artefacts/Release/VST3/ZL Compressor.vst3" $out/lib/vst3/
    install -Dm755 "ZLCompressor_artefacts/Release/Standalone/ZL Compressor" $out/bin/
  ''
  + lib.optionalString clangStdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications
    cp -r ZLCompressor_artefacts/Release/{AU,VST3} $out/
    cp -r ZLCompressor_artefacts/Release/Standalone/* $out/Applications/
  ''
  + ''
    runHook postInstall
  '';

  meta = {
    homepage = "https://zl-audio.github.io/plugins/zlcompressor/";
    description = "Versatile compressor plugin for VST3, LV2 and standalone";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      magnetophon
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
