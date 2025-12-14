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
  libXcursor,
  libXext,
  libXinerama,
  libXrandr,
  libepoxy,
  libjack2,
  libxkbcommon,
  lv2,
}:

clangStdenv.mkDerivation (finalAttrs: {
  pname = "zlsplitter";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "ZL-Audio";
    repo = "ZLSplitter";
    tag = "${finalAttrs.version}";
    hash = "sha256-8a/t1yJG5CUr4udnKIy80exQejDy0HzOi7uMjelPldg=";
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
    libXcursor
    libXext
    libXinerama
    libXrandr
    libepoxy
    libjack2
    libxkbcommon
  ];

  # JUCE dlopen's these at runtime, crashes without them
  NIX_LDFLAGS = lib.optionalString clangStdenv.hostPlatform.isLinux (toString [
    "-lX11"
    "-lXext"
    "-lXcursor"
    "-lXinerama"
    "-lXrandr"
  ]);

  # LTO needs special setup on Linux
  postPatch = lib.optionalString clangStdenv.hostPlatform.isLinux ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'juce::juce_recommended_lto_flags' '# Not forcing LTO'
  '';

  cmakeFlags = [
    # see: https://github.com/ZL-Audio/ZlEqualizer#clone-and-build
    (lib.cmakeFeature "KFR_ARCHS" (
      if clangStdenv.hostPlatform.isAarch64 then "neon64" else "sse2;avx;avx2"
    ))
    (lib.cmakeBool "ZL_JUCE_COPY_PLUGIN" false)
  ];

  installPhase = ''
    runHook preInstall
  ''
  + lib.optionalString clangStdenv.hostPlatform.isLinux ''
    mkdir -p $out/lib/{lv2,vst3}
    mkdir -p $out/bin/
    cp -r "ZLSplitter_artefacts/Release/LV2/ZL Splitter.lv2" $out/lib/lv2/
    cp -r "ZLSplitter_artefacts/Release/VST3/ZL Splitter.vst3" $out/lib/vst3/
    install -Dm755 "ZLSplitter_artefacts/Release/Standalone/ZL Splitter" $out/bin/
  ''
  + lib.optionalString clangStdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications
    cp -r ZLSplitter_artefacts/Release/{AU,VST3} $out/
    cp -r ZLSplitter_artefacts/Release/Standalone/* $out/Applications/
  ''
  + ''
    runHook postInstall
  '';

  meta = {
    homepage = "https://zl-audio.github.io/plugins/zlsplitter/";
    description = "Versatile splitter plugin for VST3, LV2 and standalone";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      magnetophon
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
