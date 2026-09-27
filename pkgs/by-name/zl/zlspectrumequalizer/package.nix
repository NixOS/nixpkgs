{
  lib,
  clangStdenv,
  fetchFromGitHub,
  nix-update-script,

  # nativeBuildInputs
  cmake,
  darwin,
  ninja,
  pkg-config,
  python3,
  writableTmpDirAsHomeHook,

  # buildInputs
  alsa-lib,
  fontconfig,
  freetype,
  libxcursor,
  libxext,
  libxi,
  libxinerama,
  libxrandr,
  lv2,
  # Highway is built static-dispatch only upstream (HWY_COMPILE_ONLY_STATIC is
  # forced ON), so exactly one ISA is baked in -- there is no runtime dispatch.
  # Default to the portable baseline so the cached binary runs everywhere nixpkgs
  # targets. Override for a faster *local* build, e.g.
  #   zlspectrumequalizer.override { simdTarget = "AVX2"; }
  # SSE4/AVX2 map to -march=x86-64-v2/v3 and will SIGILL on CPUs lacking that ISA,
  # which is why this must not be raised for the binary cache.
  simdTarget ? (if clangStdenv.hostPlatform.isAarch64 then "NEON" else "SSE2"),
}:
assert lib.assertOneOf "simdTarget" simdTarget [
  "SSE2"
  "SSE4"
  "AVX2"
  "NEON"
];
clangStdenv.mkDerivation (finalAttrs: {
  pname = "zlspectrumequalizer";
  version = "0.1.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "ZL-Audio";
    repo = "ZlSpectrumEqualizer";
    tag = finalAttrs.version;
    hash = "sha256-h4GZlyWieE1LVDr+SC3k2uklrqh5r8KQywW0+Ksa27E=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    python3
    writableTmpDirAsHomeHook
  ]
  ++ lib.optionals clangStdenv.hostPlatform.isDarwin [ darwin.sigtool ];

  buildInputs = [
    fontconfig
    freetype
    lv2
  ]
  ++ lib.optionals clangStdenv.hostPlatform.isLinux [
    alsa-lib
    libxcursor
    libxext
    libxi
    libxinerama
    libxrandr
  ];

  env = lib.optionalAttrs clangStdenv.hostPlatform.isLinux {
    # JUCE dlopen's these at runtime, crashes without them
    # -lXi is essential: JUCE requests the unversioned
    # "libXi.so", which no host has already loaded, and when that dlopen fails
    # JUCE still believes XInput2 is present (the stub for the missing
    # XIQueryVersion returns 0, which equals Success), so it discards all core
    # pointer events and the GUI stops responding to the mouse entirely.
    NIX_LDFLAGS = toString [
      "-lX11"
      "-lXcursor"
      "-lXext"
      "-lXi"
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
    (lib.cmakeFeature "ZL_HWY_STATIC_TARGET" simdTarget)
    (lib.cmakeBool "ZL_JUCE_COPY_PLUGIN" false)
    # set the version for the settings screen.
    (lib.cmakeFeature "FOOBAR_VERSION" "${finalAttrs.version}")
  ];

  installPhase = ''
    runHook preInstall
  ''
  + lib.optionalString clangStdenv.hostPlatform.isLinux ''
    mkdir -p $out/lib/{lv2,vst3}
    cp -r "ZLSpectrumEqualizer_artefacts/Release/LV2/ZL Spectrum Equalizer.lv2" $out/lib/lv2/
    cp -r "ZLSpectrumEqualizer_artefacts/Release/VST3/ZL Spectrum Equalizer.vst3" $out/lib/vst3/
    install -Dm755 -t $out/bin "ZLSpectrumEqualizer_artefacts/Release/Standalone/ZL Spectrum Equalizer"
  ''
  + lib.optionalString clangStdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications
    cp -r ZLSpectrumEqualizer_artefacts/Release/{AU,VST3} $out/
    cp -r ZLSpectrumEqualizer_artefacts/Release/Standalone/* $out/Applications/
  ''
  + ''
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://zl-audio.github.io/plugins/zlspeceq/";
    changelog = "https://github.com/ZL-Audio/ZlSpectrumEqualizer/releases/tag/${finalAttrs.version}";
    description = "Dynamic spectrum equalizer plugin for VST3, LV2 and standalone";
    mainProgram = "ZL Spectrum Equalizer";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      magnetophon
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
